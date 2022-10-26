---@diagnostic disable: need-check-nil
local extras = {}
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local exp = vim.fn.expand
local utils = require("omega.utils")

-- TODO: save files (cache)

-- Commands to execute file types
local files = {
    python = "python3 " .. vim.fn.stdpath("data") .. "/temp",
    lua = "lua " .. vim.fn.stdpath("data") .. "/temp",
    applescript = "osascript " .. vim.fn.stdpath("data") .. "/temp",
    c = "gcc -o tmp "
        .. vim.fn.stdpath("data")
        .. "/temp"
        .. " && "
        .. vim.fn.stdpath("data")
        .. "/temp"
        .. "&& rm "
        .. vim.fn.stdpath("data")
        .. "/temp",
    cpp = "clang++ -o tmp " .. vim.fn.stdpath("data") .. "/temp" .. " && " .. vim.fn.stdpath(
        "data"
    ) .. "/temp" .. "&& rm " .. vim.fn.stdpath("data") .. "/temp",
    rust = "rustc -o "
        .. vim.fn.stdpath("data")
        .. "/tmp "
        .. vim.fn.stdpath("data")
        .. "/temp"
        .. " && "
        .. vim.fn.stdpath("data")
        .. "/tmp"
        .. "&& rm "
        .. vim.fn.stdpath("data")
        .. "/temp"
        .. "&& rm "
        .. vim.fn.stdpath("data")
        .. "/tmp",
    ---@diagnostic disable-next-line: missing-parameter
    javascript = "node " .. exp("%:t"),
    ---@diagnostic disable-next-line: missing-parameter
    typescript = "tsc " .. exp("%:t") .. " && node " .. exp("%:t:r") .. ".js",
}
local scratch_buf
local og_win

local function run_file()
    local lines = vim.api.nvim_buf_get_lines(scratch_buf, 0, -1, false)
    local file = io.open(vim.fn.stdpath("data") .. "/temp", "w")
    for _, line in ipairs(lines) do
        file:write(line)
    end
    file:close()
    local command = files[vim.bo.filetype]
    if command ~= nil then
        require("toggleterm.terminal").Terminal
            :new({ cmd = command, close_on_exit = false, direction = "float" })
            :toggle()
        print("Running: " .. command)
    end
end

local function open_scratch_buffer(language)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "q",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true }
    )
    local width = vim.api.nvim_win_get_width(og_win)
    local height = vim.api.nvim_win_get_height(og_win)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        win = 0,
        width = math.floor(width * 0.8),
        height = math.floor(height * 0.8),
        col = math.floor(width * 0.1),
        row = math.floor(height * 0.1),
        border = "single",
        style = "minimal",
    })
    vim.api.nvim_buf_set_option(buf, "filetype", language)
    scratch_buf = buf
    vim.keymap.set("n", "<leader>r", function()
        run_file()
    end, {
        noremap = true,
        buffer = buf,
        desc = false,
    })
end

local open_scratch = function(bufnr)
    local entry = action_state.get_selected_entry()
    actions.close(bufnr)

    if entry ~= nil then
        open_scratch_buffer(entry[1])
    end
end

local scratch_filetypes = {
    "lua",
    "rust",
    "python",
    "c",
    "cpp",
    "java",
    "tex",
    "javascript",
    "typescrip",
    "plain",
    "norg",
}

function extras.scratch_buf(args)
    og_win = vim.api.nvim_get_current_win()
    if args.fargs[1] and vim.tbl_contains(scratch_filetypes, args.fargs[1]) then
        open_scratch_buffer(args.fargs[1])
        return
    end
    local opts = {}
    opts.data = scratch_filetypes
    pickers
        .new(opts, {
            prompt_title = "~ Scratch Picker ~",
            results_title = "~ Scratch Filetypes ~",
            -- layout_strategy = "custom_bottom",
            finder = finders.new_table(opts.data),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(_, map)
                map("i", "<CR>", open_scratch)
                map("n", "<CR>", open_scratch)
                return true
            end,
        })
        :find()
end

function extras.view_highlights()
    local bufnr = vim.api.nvim_create_buf(false, true)
    local output = vim.split(vim.fn.execute("highlight"), "\n")
    local hl_groups = {}
    for _, v in ipairs(output) do
        if v ~= "" then
            if v:sub(1, 1) == " " then
                local part_of_old = v:match("%s+(.*)")
                hl_groups[#hl_groups] = hl_groups[#hl_groups] .. part_of_old
            else
                table.insert(hl_groups, v)
            end
        end
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, hl_groups)
    for k, v in ipairs(hl_groups) do
        local startPos = string.find(v, "xxx", 1, true) - 1
        local endPos = startPos + 3
        local hlgroup = string.match(v, "([^ ]*)%s+.*")
        pcall(vim.api.nvim_buf_add_highlight, bufnr, 0, hlgroup, k - 1, startPos, endPos)
    end
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "q",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true }
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<ESC>",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true }
    )
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)
    local win = vim.api.nvim_open_win(bufnr, true, {
        relative = "win",
        win = 0,
        width = math.floor(width * 0.8),
        height = math.floor(height * 0.8),
        col = 5,
        row = 0,
        border = "single",
        style = "minimal",
    })
    vim.api.nvim_win_call(win, function()
        vim.cmd.ColorizerAttachToBuffer()
    end)
end

local ns = vim.api.nvim_create_namespace("block_edit")
function extras.block_edit_operator()
    local old_func = vim.go.operatorfunc
    _G.op_func_formatting = function(mode)
        local start = vim.api.nvim_buf_get_mark(0, "[")
        local finish = vim.api.nvim_buf_get_mark(0, "]")
        local select_start = start
        local select_finish = finish
        local win_og = vim.api.nvim_get_current_win()
        if mode == "line" then
            start[2] = 0
            finish[2] = #vim.api.nvim_buf_get_lines(0, finish[1] - 1, finish[1], false)[1]
            select_finish[2] = select_finish[2] - 1
        end
        local text =
            vim.api.nvim_buf_get_text(0, start[1] - 1, start[2], finish[1] - 1, finish[2] + 1, {})
        local ft = vim.bo.ft
        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].ft = ft
        vim.api.nvim_buf_set_text(buf, 0, 0, 0, 0, { string.rep(" ", start[2]) })
        vim.api.nvim_buf_set_text(buf, 0, start[2], 0, start[2], text)
        vim.api.nvim_buf_set_extmark(
            buf,
            ns,
            0,
            0,
            { virt_text = { { string.rep("x", start[2]), "@comment" } }, virt_text_pos = "overlay" }
        )
        local col = vim.fn.getwininfo(win_og)[1].textoff
        local winnr = vim.api.nvim_open_win(buf, true, {
            relative = "win",
            bufpos = { start[1], col },
            width = vim.o.columns - 10,
            height = #text,
            col = col,
            row = -1,
            border = "none",
            style = "minimal",
        })
        vim.wo[winnr].winhighlight = "NormalFloat:NeorgCodeblock"
        vim.api.nvim_win_set_cursor(winnr, { 1, select_start[2] })
        vim.keymap.set("n", "<cr>", function()
            local new_text = vim.api.nvim_buf_get_text(
                buf,
                0,
                start[2],
                vim.api.nvim_buf_line_count(buf) - 1,
                -1,
                {}
            )

            vim.api.nvim_win_close(winnr, true)
            vim.api.nvim_buf_set_text(
                0,
                select_start[1] - 1,
                select_start[2],
                select_finish[1] - 1,
                select_finish[2] + 1,
                new_text
            )
        end, { noremap = true, buffer = buf })

        _G.op_func_formatting = nil
    end
    vim.go.operatorfunc = "v:lua.op_func_formatting"
    vim.api.nvim_feedkeys("g@", "n", false)
end

return extras
