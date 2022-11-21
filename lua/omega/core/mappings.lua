local map = vim.keymap.set

local wk = require("which-key")
map("n", "<leader>S", function()
    vim.cmd.FormatWrite()
end, { desc = " Format" })
map("n", "<leader>W", function()
    vim.cmd.write()
end, { desc = " Write" })
map("n", "<leader>y", '"+y', { desc = " Yank to clipboard" })
map("n", "<leader>qn", function()
    vim.cmd.cnext()
end, { desc = " Quickfix Next Entry" })
map("n", "<leader>qp", function()
    vim.cmd.cprevious()
end, { desc = " Quickfix Previous Entry" })
map("n", "<leader>qo", function()
    vim.cmd.copen()
end, { desc = " Quickfix Open" })
map("n", "<leader>io", function()
    local lines = {}
    for _ = 1, math.max(vim.v.count, 1) do
        table.insert(lines, "")
    end
    vim.api.nvim_buf_set_lines(
        0,
        vim.api.nvim_win_get_cursor(0)[1],
        vim.api.nvim_win_get_cursor(0)[1],
        false,
        lines
    )
end, { desc = " Insert Empty Line Below" })
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
end, { desc = " Insert Empty Line Above" })
map("n", "<leader>ii", "i <ESC>l", { desc = " Insert Space Before" })
map("n", "<leader>ia", "a <ESC>h", { desc = " Insert Space After" })
map("n", "<leader>i<cr>", "i<CR><ESC>", { desc = " Insert Linebreak at Cursor" })

wk.register({
    q = {
        name = " Quickfix",
    },
    i = {
        name = " Insert",
    },

    v = {
        name = " View",
    },
    m = {
        name = " Messages",
    },
    P = {
        name = " Packer",
    },
}, {
    prefix = "<leader>",
    mode = "n",
    silent = true,
})

map("n", "<leader>vl", function()
    require("omega.utils").LatexPreview()
end, { desc = " View Latex" })
map("n", "<leader>vf", function()
    require("nabla").toggle_virt()
end, { desc = " View Formulas" })
map("n", "<leader>vh", function()
    vim.cmd.TSHighlightCapturesUnderCursor()
end, { desc = " View Highlight Groups" })
map("n", "<leader>vm", function()
    require("omega.utils").MarkdownPreview()
end, { desc = " View Markdown" })

map("n", "<leader>mv", function()
    require("omega.utils").view_messages()
end, { desc = " Messages View" })
map("n", "<leader>ms", "<cmd>messages<cr>", { desc = " Messages Show" })
map("n", "<leader>my", function()
    vim.cmd.let([[@0 = execute('messages')]])
end, { desc = " Messages Yank" })
map("n", "<leader>mc", function()
    vim.cmd.let([[@+ = execute('messages')]])
end, { desc = " Messages Copy to Clipboard" })

map("n", "<leader>p", '"0p', { desc = " Paste Last Yank" })
map("n", "<leader>Q", ":let @q='<c-r><c-r>q", { desc = " Edit Macro Q" })

map("n", "<leader>PS", "<cmd>PackerStatus<cr>", { desc = " Packer Status" })
map("n", "<leader>Ps", "<cmd>PackerSync<cr>", { desc = " Packer Sync" })
map("n", "<leader>Pc", "<cmd>PackerCompile<cr>", { desc = " Packer Compile" })
map("n", "<leader>PP", "<cmd>PackerProfile<cr>", { desc = " Packer Profile" })
map("n", "<leader>Pi", "<cmd>PackerInstall<cr>", { desc = " Packer Install" })
map("n", "<leader>Pu", "<cmd>PackerUpdate<cr>", { desc = " Packer Update" })
map("n", "<leader>Pc", "<cmd>PackerClean<cr>", { desc = " Packer Clean" })

map("n", ",,", function()
    require("omega.utils").append_comma()
end, {
    noremap = true,
    silent = true,
    desc = "Append comma",
})

map("n", ";;", function()
    require("omega.utils").append_semicolon()
end, {
    noremap = true,
    silent = true,
    desc = "Append semicolon",
})

map(
    "n",
    "<esc>",
    "<cmd>nohl<cr>",
    { noremap = true, silent = true, desc = "Clear highlight from search" }
)

map("s", "<leader><tab>", function()
    require("luasnip").expand_or_jump()
end, {
    noremap = true,
    silent = true,
    desc = "Expand snippet or jump",
})

map(
    "v",
    "<leader>s",
    ":s///g<LEFT><LEFT><LEFT>",
    { noremap = true, desc = "Substitue on visual selection" }
)
map("n", "<C-f>", function()
    vim.cmd(":vert :h " .. vim.fn.expand("<cword>"))
end, { noremap = true, silent = true, desc = "Open helpfile of word under cursor" })
map("i", "<m-cr>", "<cr>", { noremap = true, silent = true, desc = "Unmapped <cr>" })

map("n", "<c-j>", ":wincmd j<CR>", { noremap = true, silent = true, desc = "Move to split above" })
map(
    "n",
    "<c-h>",
    ":wincmd h<CR>",
    { noremap = true, silent = true, desc = "Move to split on left side" }
)
map("n", "<c-k>", ":wincmd k<CR>", { noremap = true, silent = true, desc = "Move to split below" })
map(
    "n",
    "<c-l>",
    ":wincmd l<CR>",
    { noremap = true, silent = true, desc = "Move to split on right side" }
)
map("x", "<", "<gv", { noremap = true, desc = "Shift left and reselect" })
map("x", ">", ">gv", { noremap = true, desc = "Shift left and reselect" })

map("n", "<C-U>", function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("b~", "n", true)
    vim.defer_fn(function()
        vim.api.nvim_win_set_cursor(0, cursor)
    end, 1)
end, {
    noremap = true,
    silent = true,
    desc = "Change case of word under cursor",
})
map("n", "Q", "@q", { noremap = true, silent = true, desc = "Execute macro q" })

-- add j and k with count to jumplist
map(
    "n",
    "j",
    [[(v:count > 1 ? "m'" . v:count : '') . 'j']],
    { noremap = true, expr = true, desc = "Add j with count to jumplist" }
)
map(
    "n",
    "k",
    [[(v:count > 1 ? "m'" . v:count : '') . 'k']],
    { noremap = true, expr = true, desc = "Add k with count to jumplist" }
)

map("v", "<leader>p", '"_dP', { noremap = true, silent = true })

-- change case of word
map("i", "<C-U>", "<ESC>b~hea", { noremap = true, silent = true })
-- change case of second letter of word
map("i", "<C-h>", "<esc>blgulhea", { noremap = true, silent = true })
map("s", "t", "a<bs>t", { noremap = true })
map("s", "f", "a<bs>f", { noremap = true })
map("n", "<leader><tab>", "<c-^>", { noremap = true, desc = "Go to alternate file" })
-- inner field
map("o", "iF", ":<c-u>normal! T=vt,<cr>", { noremap = true, silent = true })
-- outer field
map("o", "aF", ":<c-u>normal! T=vf,<cr>", { noremap = true, silent = true })

map("i", "<c-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", { noremap = true, silent = true })
-- Get rid of some weird delay
map("n", "dd", "ddjk", { noremap = true, silent = true })
map("n", "cc", "cc<left>", { noremap = true, silent = true })

map("n", "Gcl", "~<left>i", { noremap = true, silent = true })

map("i", " ", "<left>", { noremap = true })
map("n", "gm", function()
    require("omega.extras").block_edit_operator()
end, { noremap = true })
map("v", "gm", function()
    require("omega.extras").block_edit_operator()
end, { noremap = true })
map("n", "0", function()
    if vim.fn.match(vim.fn.getline(vim.fn.line(".")), [[\S]]) == (vim.fn.col(".") - 1) then
        return "0"
    else
        return "^"
    end
end, { noremap = true, expr = true })
