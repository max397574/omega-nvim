vim.keymap.set("i", "x", function()
    local og_buf = vim.api.nvim_get_current_buf()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)

    vim.api.nvim_paste("test", false, -1)

    vim.api.nvim_win_set_buf(0, og_buf)
end)

-- test
