-- Copyright: max397574 on github
local M = {}

-- TODO: add a way to output output of command (e.g. when failed to add dependency)

local exp = vim.fn.expand

M.ty_lsp_id = nil

local function has_inline_metadata()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    return lines[1] == "# /// script"
end

local subcommand_tbl = {
    add = {
        impl = function(args, _)
            local dep
            if #args <= 0 then
                vim.ui.input({ prompt = "Dependency > " }, function(input)
                    dep = input
                end)
            else
                dep = args[1]
            end
            M.add_dependency(dep)
        end,
        complete = function(subcmd_arg_lead)
            local add_args = { "numpy", "sympy", "matplotlib", "scipy" }
            return vim.iter(add_args)
                :filter(function(add_arg)
                    return add_arg:find(subcmd_arg_lead) ~= nil
                end)
                :totable()
        end,
    },
    run = {
        impl = function()
            M.run_in_split()
        end,
    },
}

local function python_cmd(opts)
    local fargs = opts.fargs
    local subcommand_key = fargs[1]
    local args = #fargs > 1 and vim.list_slice(fargs, 2, #fargs) or {}
    local subcommand = subcommand_tbl[subcommand_key]
    if not subcommand then
        vim.notify("Python: Unknown command: " .. subcommand_key, vim.log.levels.ERROR)
        return
    end
    subcommand.impl(args, opts)
end

--- Gets command with which file can be run
function M.get_run_command()
    if has_inline_metadata() then
        return "uv run --script " .. exp("%:t")
    elseif not vim.tbl_isempty(vim.fs.find("pyproject.toml", { upward = true })) then
        return "uv run " .. exp("%:t")
    else
        return "uv run python  " .. exp("%:t")
    end
end

local function add_metadata_header()
    -- TODO: instead of writing file use `--bare` option: https://github.com/astral-sh/uv/pull/17162/
    local filepath = vim.fn.expand("%:p")
    local relpath = vim.fn.fnamemodify(filepath, ":.")
    vim.cmd.w()
    vim.system({ "uv", "init", "--script", relpath }, { text = true }):wait()
end

function M.add_dependency(dependency)
    if has_inline_metadata() then
        vim.system({ "uv", "add", "--script", exp("%:t"), dependency }, { text = true }):wait()
    elseif not vim.tbl_isempty(vim.fs.find("pyproject.toml", { upward = true })) then
        vim.system({ "uv", "add", dependency }, { text = true }):wait()
    else
        add_metadata_header()
        vim.system({ "uv", "add", "--script", exp("%:t"), dependency }, { text = true }):wait()
    end
    vim.cmd.e()
    vim.cmd.w()
    if M.ty_lsp_id ~= nil then
        vim.lsp.stop_client(M.ty_lsp_id, false)
        M.start_lsp()
    end
end

function M.run_in_split()
    vim.cmd("botright split")
    vim.cmd("terminal " .. M.get_run_command())
    vim.keymap.set("n", "q", function()
        vim.cmd.bd()
    end, { buffer = true })
end

function M.setup_auto_metadata()
    vim.api.nvim_create_autocmd("BufNewFile", {
        pattern = "*.py",
        callback = function()
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            if lines[1] ~= "# /// script" then
                local filepath = vim.fn.expand("%:p")
                local relpath = vim.fn.fnamemodify(filepath, ":.")
                -- TODO: instead of writing file use `--bare` option: https://github.com/astral-sh/uv/pull/17162/
                vim.cmd.w()
                vim.system({ "uv", "init", "--script", relpath }, { text = true }):wait()
                vim.cmd.e()
            end
        end,
    })
end

function M.start_lsp()
    local cmd, name, root_dir
    if has_inline_metadata() then
        local filepath = vim.fn.expand("%:p")
        name = "ty-" .. vim.fn.fnamemodify(filepath, ":t")
        local relpath = vim.fn.fnamemodify(filepath, ":.")
        cmd = { "uvx", "--with-requirements", relpath, "ty", "server" }
        root_dir = vim.fn.getcwd()
    else
        name = "ty"
        cmd = { "uvx", "ty", "server" }
        root_dir = vim.fs.root(0, { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" })
            or vim.fn.getcwd()
    end

    M.ty_lsp_id = vim.lsp.start({
        name = name,
        cmd = cmd,
        root_dir = root_dir,
    })
end

function M.setup()
    vim.lsp.config("ruff", {
        cmd = { "ruff", "server" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
        settings = {},
    })

    vim.lsp.enable("ruff")

    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
            vim.lsp.buf.format({
                filter = function(client)
                    return client.name == "ruff"
                end,
            })
        end,
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function(_)
            M.start_lsp()
        end,
    })

    vim.api.nvim_create_user_command("Python", python_cmd, {
        nargs = "+",
        desc = "Command for python utils",
        complete = function(arg_lead, cmdline, _)
            local subcmd_key, subcmd_arg_lead = cmdline:match("^['<,'>]*Python[!]*%s(%S+)%s(.*)$")
            if
                subcmd_key
                and subcmd_arg_lead
                and subcommand_tbl[subcmd_key]
                and subcommand_tbl[subcmd_key].complete
            then
                return subcommand_tbl[subcmd_key].complete(subcmd_arg_lead)
            end
            if cmdline:match("^['<,'>]*Python[!]*%s+%w*$") then
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
