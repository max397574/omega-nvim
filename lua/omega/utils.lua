local utils = {}

local read_buffers = {}
--- Go to last place in file
function utils.last_place()
    if not vim.tbl_contains(vim.api.nvim_list_bufs(), vim.api.nvim_get_current_buf()) then
        return
    elseif vim.tbl_contains(read_buffers, vim.api.nvim_get_current_buf()) then
        return
    end
    table.insert(read_buffers, vim.api.nvim_get_current_buf())
    -- check if filetype isn't one of the listed
    if not vim.tbl_contains({ "gitcommit", "help", "packer", "toggleterm" }, vim.bo.ft) then
        -- check if mark `"` is inside the current file (can be false if at end of file and stuff got deleted outside neovim)
        -- if it is go to it
        vim.cmd([[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]])
        -- get cursor position
        local cursor = vim.api.nvim_win_get_cursor(0)
        -- if there are folds under the cursor open them
        if vim.fn.foldclosed(cursor[1]) ~= -1 then
            vim.cmd.normal({ "zO", bang = true })
        end
    end
end

function utils.get_themes()
    local theme_paths = vim.api.nvim_get_runtime_file("lua/omega/colors/themes/*", true)
    local themes = {}
    for _, path in ipairs(theme_paths) do
        local theme = path:gsub(".*/lua/omega/colors/themes/", ""):gsub(".lua", "")
        table.insert(themes, theme)
    end
    return themes
end

--- Retunrs a border
---@return table<string, string> border char, highlight
function utils.border()
    return {
        { "╭", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╮", "FloatBorder" },
        { "│", "FloatBorder" },
        { "╯", "FloatBorder" },
        { "─", "FloatBorder" },
        { "╰", "FloatBorder" },
        { "│", "FloatBorder" },
    }
end

local function split(str)
    local t = {}
    for word in str:gmatch("%S+") do
        table.insert(t, word)
    end
    return t
end

local function diff_strings(real, expected)
    local buf1 = vim.api.nvim_create_buf(false, true)
    local buf2 = vim.api.nvim_create_buf(false, true)

    local width = math.floor(vim.o.columns * 0.5) - 4
    local height = math.min(math.floor(vim.o.lines * 0.8), math.max(#real, #expected))
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor(vim.o.columns / 2)

    local opts1 = {
        style = "minimal",
        relative = "editor",
        row = row,
        col = 1,
        width = width,
        height = height,
        border = "rounded",
        title = "Expected",
    }

    vim.api.nvim_buf_set_lines(buf1, 0, -1, false, expected)
    vim.api.nvim_buf_set_lines(buf2, 0, -1, false, real)

    vim.api.nvim_open_win(buf1, true, opts1)
    local opts2 = opts1
    opts2.col = col
    opts2.title = "Gotten"
    vim.api.nvim_open_win(buf2, true, opts2)
end

local function compare(lines, output_lines)
    local i = 1
    local j = 1
    while i <= #lines or j <= #output_lines do
        while i <= #lines and vim.trim(lines[i]) == "" do
            i = i + 1
        end
        while j <= #output_lines and vim.trim(output_lines[j]) == "" do
            j = j + 1
        end

        if i > #lines or j > #output_lines then
            return i > #lines and j > #output_lines
        end

        local lhs, rhs = vim.trim(lines[i]), vim.trim(output_lines[j])
        if lhs ~= rhs then
            return false
        end

        i = i + 1
        j = j + 1
    end
    return true
end

local last_values = {}

local function check(filename)
    local input = last_values[filename][1]
    local expected_output = last_values[filename][2]

    local compile_obj = vim.system({
        "rustc",
        "--edition",
        "2024",
        "-o",
        vim.fn.stdpath("data") .. "/tmp",
        filename,
    }):wait()

    local real_output
    if compile_obj.stderr ~= nil and #compile_obj.stderr > 0 and compile_obj.stderr:find("error") then
        real_output = vim.fn.split("Error:\n" .. compile_obj.stderr, "\n")
    else
        local obj = vim.system({ vim.fn.stdpath("data") .. "/tmp" }, {
            stdin = input,
            timeout = 5000,
        }):wait()
        real_output = vim.fn.split(obj.stdout, "\n")
        if obj.stderr ~= nil and #obj.stderr > 0 then
            real_output = vim.fn.split("Error:\n" .. obj.stderr, "\n")
        end

        if obj.code == 124 then
            real_output = { "TIMEOUT" }
        end

        vim.system({
            "rm",
            vim.fn.stdpath("data") .. "/tmp",
        })
    end

    local elapsed = ""

    if real_output[1]:find("Elapsed") then
        elapsed = real_output[1]
        table.remove(real_output, 1)
    end

    local same = compare(real_output, expected_output)
    local message = ""
    local type = nil
    if same then
        message = "Test Case passed ✓" .. (elapsed ~= "" and "\n" .. elapsed or "")
        type = "success"
    else
        diff_strings(real_output, expected_output)
        message = "Test Case failed"
        type = "error"
    end

    vim.notify(message, type)
end

function utils.test_CF(reuse_old_values)
    local filename = vim.fn.expand("%")

    if reuse_old_values and last_values[filename] ~= nil then
        check(filename)
        return
    end

    local input_buf = vim.api.nvim_create_buf(false, true)
    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.4)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local opts = {
        style = "minimal",
        relative = "editor",
        row = row,
        col = col,
        width = width,
        height = height,
        border = "rounded",
        title = "Input",
    }

    local win = vim.api.nvim_open_win(input_buf, true, opts)
    vim.wo[win].wrap = false
    vim.wo[win].linebreak = true

    vim.cmd("startinsert")
    vim.keymap.set("n", "<CR>", function()
        local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
        local input = table.concat(lines, "\n")
        vim.api.nvim_buf_set_lines(input_buf, 0, -1, false, {})

        vim.api.nvim_win_set_config(win, { title = "Expected Output" })
        vim.cmd("startinsert")
        vim.keymap.set("n", "<CR>", function()
            local expected_output = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
            last_values[filename] = { input, expected_output }
            vim.api.nvim_win_close(win, true)
            vim.api.nvim_buf_delete(input_buf, { force = true })
            check(filename)
        end, { buffer = input_buf })
    end, { buffer = input_buf })
end

return utils
