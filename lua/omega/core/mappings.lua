local map = vim.keymap.set

local wk = require("which-key")
wk.register({
    y = { '"+y', " Yank to clipboard" },
    ["W"] = {
        function()
            vim.cmd.w()
        end,
        " Write",
    },
    ["S"] = {
        function()
            vim.cmd.FormatWrite()
        end,
        " Format",
    },
    q = {
        name = " Quickfix",
        n = { "<cmd>cnext<CR>", "Next Entry" },
        p = { "<cmd>cprevious<CR>", "Previous Entry" },
        o = { "<cmd>copen<CR>", "Open" },
    },
    w = {
        name = " Window",
        ["w"] = { "<C-W>p", "Previous" },
        ["d"] = { "<C-W>c", "Delete" },
        ["-"] = { "<C-W>s", "Split below" },
        ["|"] = { "<C-W>v", "Split right" },
        ["2"] = { "<C-W>v", "Layout Double Columns" },
        ["h"] = { "<C-W>h", "Window left" },
        ["j"] = { "<C-W>j", "Window below" },
        ["l"] = { "<C-W>l", "Window right" },
        ["k"] = { "<C-W>k", "Window up" },
        ["H"] = { "<C-W>5<", "Expand left" },
        ["J"] = { ":resize +5<CR>", "Expand below" },
        ["L"] = { "<C-W>5>", "Expand right" },
        ["K"] = { ":resize -5<CR>", "Expand up" },
        ["="] = { "<C-W>=", "Balance" },
        ["s"] = { "<C-W>s", "Split below" },
        ["v"] = { "<C-W>v", "Split right" },
    },
    i = {
        name = " Insert",
        o = {
            function()
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
            end,
            "Empty line below",
        },
        O = {
            function()
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
            end,
            "Empty line above",
        },
        i = { "i <ESC>l", "Space before" },
        a = { "a <ESC>h", "Space after" },
        e = { "<cmd>Telescope emoji<cr>", "Emoji" },
        ["<CR>"] = { "i<CR><ESC>", "Linebreak at Cursor" },
    },

    v = {
        name = " View",
        l = {
            function()
                require("omega.utils").LatexPreview()
            end,
            "Latex",
        },
        f = {
            function()
                ---@diagnostic disable-next-line: undefined-field
                require("nabla").toggle_virt()
            end,
            "Formulas",
        },
        h = {
            function()
                vim.cmd.TSHighlightCapturesUnderCursor()
            end,
            "Highlight Groups",
        },
        m = {
            function()
                require("omega.utils").MarkdownPreview()
            end,
            "Markdown",
        },
    },
    p = { '"0p', " Paste Last Yank" },

    Q = { ":let @q='<c-r><c-r>q", " Edit Macro Q" },

    m = {
        name = " Messages",
        v = {
            function()
                require("omega.utils").view_messages()
            end,
            "View",
        },
        s = {
            "<cmd>messages<cr>",
            "Show",
        },
        y = {
            function()
                vim.cmd.let([[@0 = execute('messages')]])
            end,
            "Yank",
        },
        c = {
            function()
                vim.cmd.let([[@+ = execute('messages')]])
            end,
            "Copy to Clipboard",
        },
    },

    ["P"] = {
        name = " Packer",
        S = { "<cmd>PackerStatus<cr>", "Status" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        p = { "<cmd>PackerProfile<cr>", "Profile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
        C = { "<cmd>PackerClean<cr>", "Clean" },
    },
}, {
    prefix = "<leader>",
    mode = "n",
    silent = true,
})

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
