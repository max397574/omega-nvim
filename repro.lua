local function setup()
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "test" })
    vim.api.nvim_win_set_cursor(0, { 1, 4 })
    vim.cmd.startinsert({ bang = true })
end
local function test_text_edit()
    vim.lsp.util.apply_text_edits({
        {
            newText = "new test text\ntest",
            range = {
                ["end"] = {
                    character = 4,
                    line = 0,
                },
                start = {
                    character = 0,
                    line = 0,
                },
            },
        },
    }, vim.api.nvim_get_current_buf(), "utf-16")
end
setup()
vim.keymap.set("i", "<cr>", function()
    test_text_edit()
end)
test_text_edit()
