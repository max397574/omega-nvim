local M = {}

local exp = vim.fn.expand

function M.utop()
    vim.cmd("botright split")
    vim.cmd("terminal utop")
    vim.cmd.startinsert()
end

local function is_dune_project()
    return not vim.tbl_isempty(vim.fs.find("dune-project", { upward = true }))
end

M.watch_job = nil

local function kill_watch_job()
    if M.watch_job then
        M.watch_job:kill(9)
        M.watch_job = nil
    end
end

function M.watch_build()
    if not is_dune_project then
        vim.notify("OCaml watch is just supported in a dune project")
        return
    end
    kill_watch_job()

    local watch_job = vim.system({ "dune", "build", "-w" }, { text = true })

    M.watch_job = watch_job

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            kill_watch_job()
        end,
    })
end

local function get_dune_package_name(filepath)
    local f = io.open(filepath, "r")
    if not f then
        return nil
    end
    local content = f:read("*all")
    f:close()
    content = content:gsub(";[^\n]*", "")
    local name = content:match("%(%s*name%s+([^%s%)]+)%s*%)")
    return name
end

function M.get_run_command(interactive)
    if is_dune_project() then
        local project_file = vim.fs.find("dune-project", { upward = true })[1]
        local cwd = vim.fs.root(0, "dune-project")
        if interactive then
            vim.fn.setreg("+", '#use "bin/main.ml";;')
            return "dune utop"
        else
            return "dune exec " .. get_dune_package_name(project_file), cwd
        end
    elseif interactive then
        return "utop -init " .. exp("%:t")
    else
        return "ocaml " .. exp("%:t")
    end
end

function M.run_in_split(interactive)
    vim.cmd("botright split")
    vim.cmd("terminal " .. M.get_run_command(interactive))
    if interactive then
        vim.cmd.startinsert()
    end
    vim.keymap.set("n", "q", function()
        vim.cmd.bd()
    end, { buffer = true })
end

local subcommand_tbl = {
    utop = {
        impl = function()
            M.utop()
        end,
    },
    watch = {
        impl = function(args, _)
            if #args > 0 then
                if args[1] == "stop" then
                    kill_watch_job()
                end
            end
            M.watch_build()
        end,
        complete = { "stop" },
    },
    run = {
        impl = function(args, _)
            if #args > 0 then
                if args[1] == "interactive" then
                    M.run_in_split(true)
                end
            else
                M.run_in_split(false)
            end
        end,
        complete = { "interactive" },
    },
}

local function ocaml_cmd(opts)
    local fargs = opts.fargs
    local subcommand_key = fargs[1]
    local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
    local subcommand = subcommand_tbl[subcommand_key]
    if not subcommand then
        vim.notify("Ocaml: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
        return
    end
    subcommand.impl(args, opts)
end

function M.setup()
    vim.lsp.enable("ocamllsp")

    vim.api.nvim_create_user_command("OCaml", ocaml_cmd, {
        nargs = "+",
        desc = "Command for OCaml utils",
        complete = function(arg_lead, cmdline, _)
            local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*OCaml[!]*%s(%S+)%s(.*)$")
            if
                subcmd_key
                and subcmd_arg_lead
                and subcommand_tbl[subcmd_key]
                and subcommand_tbl[subcmd_key].complete
            then
                if type(subcommand_tbl[subcmd_key].complete) == "table" then
                    return vim.iter(subcommand_tbl[subcmd_key].complete)
                        :filter(function(arg)
                            return arg:find(subcmd_arg_lead) ~= nil
                        end)
                        :totable()
                else
                    return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
                end
            end
            if cmdline:match("^['<,'>]*OCaml[!]*%s+%w*$") then
                local subcommand_keys = vim.tbl_keys(subcommand_tbl)
                return vim.iter(subcommand_keys)
                    :filter(function(key)
                        return key:find(arg_lead) ~= nil
                    end)
                    :totable()
            end
        end,
    })
end

return M
