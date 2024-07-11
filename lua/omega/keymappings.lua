local map = vim.keymap.set

map("i", "<m-cr>", "<cr>", { desc = "Return" })

map({ "v", "n" }, "<leader>y", '"+y', { silent = true, desc = " Yank to clipboard" })

map("n", "<esc>", function()
    pcall(require("notify").dismiss)
    vim.cmd.nohl()
end, { silent = true, desc = "Clear highlight from search and close notifications" })

map("n", "<leader>W", function()
    vim.cmd.w()
end, { desc = "󰆓 Write" })

map("n", "<leader>io", function()
    local lines = {}
    for _ = 1, math.max(vim.v.count, 1) do
        table.insert(lines, "")
    end
    vim.api.nvim_buf_set_lines(0, vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_win_get_cursor(0)[1], false, lines)
end, { desc = " Insert empty line below" })

map("n", "<leader>iO", function()
    local lines = {}
    for _ = 1, math.max(vim.v.count, 1) do
        table.insert(lines, "")
    end
    vim.api.nvim_buf_set_lines(
        0,
        vim.api.nvim_win_get_cursor(0)[1] - 1,
        vim.api.nvim_win_get_cursor(0)[1] - 1,
        false,
        lines
    )
end, { desc = " Insert empty line above" })

map("n", "<leader>ii", "i <esc>l", { desc = " Insert space before", noremap = true })
map("n", "<leader>ia", "a <esc>h", { desc = " Insert space after", noremap = true })

map("n", "<leader>p", '"0p', { desc = " Paste Last Yank", noremap = true })

map("n", "0", function()
    local line = vim.fn.getline(vim.fn.line(".") --[[@as string]]) --[[@as string]]
    if line:gsub("%s*", "") == "" then
        return "0"
    end
    if vim.fn.match(line, [[\S]]) == (vim.fn.col(".") - 1) then
        return "0"
    else
        return "^"
    end
end, { expr = true, desc = "Goto Beginning of text, then line" })

map("n", "<C-U>", function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("b~", "n", true)
    vim.defer_fn(function()
        vim.api.nvim_win_set_cursor(0, cursor)
    end, 1)
end, {
    desc = "Change case of word under cursor",
})

map("n", "<leader>Ls", function()
    require("lazy").sync()
end, { desc = "󰏗 Lazy Sync" })

map("n", "<leader>LS", function()
    require("lazy").show()
end, { desc = "󰏗 Lazy Show" })

map("n", "<leader>Lp", function()
    require("lazy").profile()
end, { desc = "󰏗 Lazy Profile" })

map("n", "<leader>Li", function()
    require("lazy").install()
end, { desc = "󰏗 Lazy Install" })

map("n", "<leader>Lu", function()
    require("lazy").update()
end, { desc = "󰏗 Lazy Update" })

map("n", "<leader>Ll", function()
    require("lazy").log()
end, { desc = "󰏗 Lazy Log" })

map("n", "<leader>Ld", function()
    require("lazy").debug()
end, { desc = "󰏗 Lazy Debug" })

map("n", "<leader>Lh", function()
    require("lazy").help()
end, { desc = "󰏗 Lazy Help" })

map("n", "<leader>qn", function()
    vim.cmd.cnext()
end, { desc = " Quickfix Next" })
map("n", "<leader>qp", function()
    vim.cmd.cprev()
end, { desc = " Quickfix Previous" })
map("n", "<leader>qo", function()
    vim.cmd.copen()
end, { desc = " Quickfix Open" })

map("n", "j", [[(v:count > 1 ? "m'" . v:count : '') . 'j']], { expr = true, desc = "Add j with count to jumplist" })
map("n", "k", [[(v:count > 1 ? "m'" . v:count : '') . 'k']], { expr = true, desc = "Add k with count to jumplist" })

map("v", ">", ">gv")
map("v", "<", "<gv")

map("n", "<C-f>", function()
    vim.cmd(":vert :h " .. vim.fn.expand("<cword>"))
end, { noremap = true, silent = true, desc = "Open helpfile of word under cursor" })

map("n", "<leader>bn", function()
    require("omega.modules.ui.tabline").next_buf()
end, { desc = " Buffer Next" })

map("n", "<leader>bp", function()
    require("omega.modules.ui.tabline").prev_buf()
end, { desc = " Buffer Previous" })

map("n", "<leader>bd", function()
    require("omega.modules.ui.tabline").close_buf(0)
end, { desc = " Buffer Close" })

map("n", "<leader>tN", function()
    vim.cmd.tabnew()
end, { desc = "  Tab New" })

map("n", "<leader>tr", function()
    require("omega.modules.ui.tabline").rename_tab()
end, { desc = "  Tab Rename" })

map("n", "<leader>tn", function()
    vim.cmd.tabnext()
end, { desc = "  Tab Next" })

map("n", "<leader>tp", function()
    vim.cmd.tabprevious()
end, { desc = "  Tab Previous" })

map("n", "<leader>td", function()
    require("omega.modules.ui.tabline").close_tab()
end, { desc = "  Tab Close" })

map("i", "<C-U>", "<ESC>b~hea", { silent = true })
