local map = vim.keymap.set

local function get_cursor()
    return vim.api.nvim_win_get_cursor(0)
end

map("n", "_", "~hi_<esc>l")

map("i", "<M-CR>", "<CR>")

map({ "v", "n" }, "<leader>y", '"+y', { silent = true })

map("n", "<leader>W", function()
    vim.cmd.w()
end)

map("n", "<leader>io", function()
    local lines = {}
    for _ = 1, math.max(vim.v.count, 1) do
        table.insert(lines, "")
    end
    vim.api.nvim_buf_set_lines(0, get_cursor()[1], get_cursor()[1], false, lines)
end)

map("n", "<leader>iO", function()
    local lines = {}
    for _ = 1, math.max(vim.v.count, 1) do
        table.insert(lines, "")
    end
    local pos = get_cursor()[1] - 1
    vim.api.nvim_buf_set_lines(0, pos, pos, false, lines)
end)

map("n", "<leader>ii", "i <esc>l")
map("n", "<leader>ia", "a <esc>h")

map("n", "<leader>p", '"0p')

map("n", "<C-U>", function()
    local cursor = get_cursor()
    vim.api.nvim_feedkeys("b~", "n", true)
    vim.defer_fn(function()
        vim.api.nvim_win_set_cursor(0, cursor)
    end, 1)
end)

map("n", "<leader>qn", function()
    vim.cmd.cnext()
end)
map("n", "<leader>qp", function()
    vim.cmd.cprev()
end)

map("n", "j", [[(v:count > 1 ? "m'" . v:count : '') . 'j']], { expr = true, desc = "Add j with count to jumplist" })
map("n", "k", [[(v:count > 1 ? "m'" . v:count : '') . 'k']], { expr = true, desc = "Add k with count to jumplist" })

map("v", ">", ">gv")
map("v", "<", "<gv")

map("n", "<leader>bn", function()
    require("omega.modules.ui.tabline").next_buf()
end)

map("n", "<leader>bp", function()
    require("omega.modules.ui.tabline").prev_buf()
end)

map("n", "<leader>bd", function()
    require("omega.modules.ui.tabline").close_buf(0)
end)

map("n", "<leader>tN", function()
    vim.cmd.tabnew()
end, { desc = "Tab New" })

map("n", "<leader>tr", function()
    require("omega.modules.ui.tabline").rename_tab()
end, { desc = "Tab Rename" })

map("n", "<leader>tn", function()
    vim.cmd.tabnext()
end, { desc = "Tab Next" })

map("n", "<leader>tp", function()
    vim.cmd.tabprevious()
end, { desc = "Tab Previous" })

map("n", "<leader>td", function()
    require("omega.modules.ui.tabline").close_tab()
end, { desc = "Tab Close" })
