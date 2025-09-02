local M = {}

function M.select_inner_dollar(outer)
    local line = vim.api.nvim_get_current_line()
    local row, col0 = unpack(vim.api.nvim_win_get_cursor(0)) -- col0 is 0-based
    local col = col0 + 1 -- make it 1-based for string ops

    -- Find previous '$' at or before cursor
    local start = nil
    for i = col, 1, -1 do
        if line:sub(i, i) == "$" then
            start = i
            break
        end
    end
    if not start then
        return
    end

    -- Find next '$' after that
    local stop = nil
    for i = start + 1, #line do
        if line:sub(i, i) == "$" then
            stop = i
            break
        end
    end
    if not stop then
        return
    end

    -- Select between the two dollars (inner)
    -- start/stop are 1-based; inner region is (start+1) .. (stop-1)
    local bufnr = 0
    local start_col0 = start -- inner start (start+1 as 0-based)
    local end_col0 = stop - 2 -- inner end (stop-1 as 0-based)

    if end_col0 < start_col0 then
        return
    end

    -- Enter visual mode programmatically and set selection
    -- row is 1-based; extmark uses 0-based row
    local ns = vim.api.nvim_create_namespace("inner_dollar_textobj")

    -- Clear previous marks for this ns
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

    if outer then
        start_col0 = start_col0 - 1
        end_col0 = end_col0 - 1
    end

    -- Set start and end of selection via marks, then use normal! v`> to select
    vim.api.nvim_buf_set_mark(bufnr, "<", row, start_col0, {})
    vim.api.nvim_buf_set_mark(bufnr, ">", row, end_col0, {})

    -- Go to start, start visual, then go to end
    vim.api.nvim_win_set_cursor(0, { row, start_col0 })
    vim.cmd("normal! v`>")
end

-- Keymaps for operator-pending ("o") and visual ("x") modes
vim.keymap.set({ "o", "x" }, "i$", function()
    M.select_inner_dollar()
end, { silent = true })
vim.keymap.set({ "o", "x" }, "a$", function()
    M.select_outer_dollar()
end, { silent = true })

return M
