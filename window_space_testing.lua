local buf = vim.api.nvim_create_buf(false, true)
local winnr = vim.api.nvim_open_win(buf, true, {
    relative = "cursor",
    border = "rounded",
    width = 115,
    height = 4,
    row = 0,
    col = 0,
    style = "minimal",
})
local height = vim.api.nvim_win_get_height(winnr)
local width = vim.api.nvim_win_get_width(winnr)
-- vim.api.nvim_win_set_height(winnr, 10)
print(height, width)
vim.wo[winnr].winhighlight = "NormalFloat:Error"
--  1234567
-- local cursor = vim.api.nvim_win_get_cursor(0)
-- local screenpos = vim.fn.screenpos(0, cursor[1], cursor[2] + 1)
-- local space_below = vim.o.lines - screenpos.row - vim.o.cmdheight - 1
--
-- local space_above = vim.fn.line(".") - vim.fn.line("w0")
-- -- local space_below = vim.fn.line("w$") - vim.fn.line(".")
-- local available_space = math.max(space_above, space_below)
-- print("above:", space_above, "below:", space_below)
-- 1
-- 2
-- 3
-- 4
-- 5
-- 6
-- 7
-- 8
-- 9
-- 10
-- 11
-- 12
-- 13
-- 14
-- 15
-- 16
-- 17
-- 18
-- 19
-- 20
-- 21
-- 22
-- 23
-- 24
-- 25
-- 26
-- 27
-- 28
-- 29
-- 30
-- 31
-- 32
-- 33
-- 34
-- 35
-- 36
-- 37
-- 38
-- 39
-- 40
-- 41
-- 42
-- 43
-- 44
-- 45
-- 46
-- 47
-- 48
-- 49
-- 50
-- 51
