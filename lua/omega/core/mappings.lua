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

map("n", "<esc>", function()
    require("notify").dismiss()
    vim.cmd.nohl()
end, { noremap = true, silent = true, desc = "Clear highlight from search" })

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
map("i", "<C-z>", "<esc>blgulhea", { noremap = true, silent = true })
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

map("i", " ", "<right>", { noremap = true })
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

-- debugging
wk.register({
    d = {
        name = " Debug",
        s = {
            name = "Step",
            o = {
                function()
                    require("dap").step_out()
                end,
                "Out",
            },
            O = {
                function()
                    require("dap").step_over()
                end,
                "Over",
            },
            i = {
                function()
                    require("dap").step_into()
                end,
                "Into",
            },
        },
        b = {
            name = "Breakpoint",
            t = {
                function()
                    require("dap").toggle_breakpoint()
                end,
                "Toggle",
            },
        },
        R = {
            function()
                require("dap").run_to_cursor()
            end,
            "Run to cursor",
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",
})

-- bufferline
wk.register({
    b = {
        name = "﩯Buffer",
        ["b"] = { "<cmd>e #<CR>", "Switch to Other Buffer" },
        ["p"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
        ["["] = { "<cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
        ["n"] = { "<cmd>BufferLineCycleNext<CR>", "Next Buffer" },
        ["]"] = { "<cmd>BufferLineCycleNext<CR>", "Next Buffer" },
        ["d"] = {
            function()
                vim.cmd.bdelete(vim.fn.bufnr("%"))
            end,
            "Delete Buffer",
        },
        ["g"] = { "<cmd>BufferLinePick<CR>", "Goto Buffer" },
    },
}, {
    prefix = "<leader>",
    mode = "n",
})

-- gitlinker
wk.register({ y = "Copy Link" }, { mode = "n", prefix = "<leader>g" })
wk.register({ g = { name = " Git", y = "Copy Link" } }, { mode = "v", prefix = "<leader>" })

-- gitsigns
wk.register({
    g = {
        name = " Git",
        h = {
            name = "Hunk",
            s = {
                function()
                    require("gitsigns").stage_hunk()
                end,
                "Stage",
            },
            p = {
                function()
                    require("gitsigns").preview_hunk()
                end,
                "Preview",
            },
            b = {
                function()
                    require("gitsigns").blame_line()
                end,
                "Blame Line",
                desc = " Git Blame Line",
            },
            R = {
                function()
                    require("gitsigns").reset_buffer()
                end,
                "Reset Buffer",
            },
            r = {
                function()
                    require("gitsigns").reset_hunk()
                end,
                "Reset Hunk",
            },
            u = {
                function()
                    require("gitsigns").undo_stage_hunk()
                end,
                "Undo Stage",
            },
        },
    },
}, {
    mode = "n",
    prefix = "<leader>",
})

-- venn
local function toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.opt_local.ve = "all"
        -- draw a line on HJKL keystokes
        vim.keymap.set("n", "J", "<C-v>j:VBox<CR>", { noremap = true, buffer = true })
        vim.keymap.set("n", "K", "<C-v>k:VBox<CR>", { noremap = true, buffer = true })
        vim.keymap.set("n", "L", "<C-v>l:VBox<CR>", { noremap = true, buffer = true })
        vim.keymap.set("n", "H", "<C-v>h:VBox<CR>", { noremap = true, buffer = true })
        -- draw a box by pressing "b" with visual selection
        vim.keymap.set("v", "b", ":VBox<CR>", { noremap = true, buffer = true })
    else
        vim.opt_local.ve = ""
        vim.keymap.del("n", "H", { buffer = 0 })
        vim.keymap.del("n", "J", { buffer = 0 })
        vim.keymap.del("n", "K", { buffer = 0 })
        vim.keymap.del("n", "L", { buffer = 0 })
        vim.keymap.del("v", "b", { buffer = 0 })
        vim.b.venn_enabled = nil
    end
end

wk.register({
    V = {
        function()
            toggle_venn()
        end,
        " Venn",
    },
}, {
    prefix = "<leader>",
    mode = "n",
})

-- treesitter
vim.keymap.set("o", "m", ":<C-U>lua require('tsht').nodes()<CR>", { noremap = true, silent = true })
vim.keymap.set("x", "m", ":<C-U>lua require('tsht').nodes()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>qw", function()
    require("query-secretary").query_window_initiate()
end, { desc = "Write Query" })

-- colorizer
wk.register(
    { c = { "<cmd>ColorizerAttachToBuffer<cr>", "Colorizer" } },
    { mode = "n", prefix = "<leader>v" }
)

-- todo
wk.register({
    t = {
        name = "璘Todo",
        q = { "<cmd>TodoQuickFix", "Quickfix" },
        t = { "<cmd>TodoTelescope<cr>", "Telescope" },
        T = { "<cmd>TodoTrouble<cr>", "Trouble" },
        l = { "<cmd>TodoLocList<CR>", "Loclist" },
    },
}, {
    mode = "n",
    prefix = "<leader>",
})

-- harpoon
wk.register({
    H = {
        name = " Harpoon",
        a = {
            function()
                require("harpoon.mark").add_file()
            end,
            "Add File",
        },
        m = {
            function()
                require("harpoon.ui").toggle_quick_menu()
            end,
            "Menu",
        },
        n = {
            function()
                require("harpoon.ui").nav_next()
            end,
            "Next File",
        },
        p = {
            function()
                require("harpoon.ui").nav_prev()
            end,
            "Previous File",
        },
        t = { "<cmd>Telescope harpoon marks<CR>", "Telescope" },
    },
    L = {
        name = " Lazy",
        s = {
            function()
                require("lazy").sync()
            end,
            "Sync",
        },
        S = {
            function()
                require("lazy").show()
            end,
            "Show",
        },
        p = {
            function()
                require("lazy").profile()
            end,
            "Profile",
        },
        i = {
            function()
                require("lazy").install()
            end,
            "Install",
        },
        u = {
            function()
                require("lazy").update()
            end,
            "Update",
        },
        l = {
            function()
                require("lazy").log()
            end,
            "Log",
        },
        d = {
            function()
                require("lazy").debug()
            end,
            "Debug",
        },
        h = {
            function()
                require("lazy").help()
            end,
            "Help",
        },
    },
    l = {
        function()
            vim.cmd.Lazy()
        end,
        " Lazy",
    },
}, {
    prefix = "<leader>",
    mode = "n",
})

-- telescope
wk.register({
    C = {
        name = " Colors",
        p = {
            function()
                require("omega.modules.telescope").api.colorscheme_switcher()
            end,
            "Pick",
        },
        s = {
            function()
                require("telescope.builtin").highlights()
            end,
            "Search",
        },
    },

    f = {
        name = " Find",
        f = {
            function()
                require("omega.modules.telescope").api.find_files()
            end,
            "File",
        },
        ["."] = {
            function()
                require("telescope.builtin").resume()
            end,
            "Repeat",
        },
    },
    ["/"] = {
        function()
            require("omega.modules.telescope").api.live_grep()
        end,
        " Live Grep",
    },
    ["h"] = {
        name = " Help",
        t = {
            function()
                require("telescope.builtin").builtin()
            end,
            "Telescope",
        },
        c = {
            function()
                require("telescope.builtin").commands()
            end,
            "Commands",
        },
        h = {
            function()
                require("omega.modules.telescope").api.help_tags()
            end,
            "Tags",
        },
    },
    ["."] = {
        function()
            require("omega.modules.telescope").api.file_browser()
        end,
        " File Browser",
    },
    [","] = {
        function()
            require("telescope.builtin").buffers()
        end,
        "﩯Buffers",
    },
    [":"] = {
        function()
            require("telescope.builtin").commands()
        end,
        " Commands",
    },

    i = {
        e = { "<cmd>Telescope emoji<cr>", "Emoji" },
    },
}, {
    prefix = "<leader>",
    mode = "n",
})
vim.keymap.set("n", "<c-s>", function()
    require("omega.modules.telescope").api.buffer_fuzzy()
end, { noremap = true })

-- trouble
wk.register({
    x = {
        name = " Errors",
        x = { "<cmd>TroubleToggle<CR>", "Trouble" },
        w = {
            "<cmd>Trouble lsp_workspace_diagnostics<CR>",
            "Workspace Trouble",
        },
        d = {
            "<cmd>Trouble lsp_document_diagnostics<CR>",
            "Document Trouble",
        },
        l = { "<cmd>lopen<CR>", "Open Location List" },
        q = { "<cmd>copen<CR>", "Open Quickfix List" },
    },
}, {
    mode = "n",
    prefix = "<leader>",
})

-- comment
wk.register({

    c = {
        name = " Comment",
        c = { "Toggle Line" },
    },
}, {
    prefix = "<leader>",
    mode = "n",
})

-- annotations
wk.register({
    a = {
        function()
            require("neogen").generate({ snippet_engine = "luasnip" })
        end,
        "﨧Annotations",
    },
}, {
    prefix = "<leader>",
    mode = "n",
})

-- ssr
wk.register({
    ["R"] = {
        name = " Refactoring",
        s = {
            function()
                require("ssr").open()
            end,
            "Structural replace",
        },
    },
}, { prefix = "<leader>", mode = "n" })
vim.keymap.set("x", "<leader>Rs", function()
    require("ssr").open()
end)

vim.keymap.set("n", "zg", function()
    if vim.bo.spelllang == "en" then
        vim.bo.spellfile = vim.fn.expand("~") .. "/.config/nvim/spell/en.utf-8.add"
    elseif vim.bo.spelllang == "de" then
        vim.bo.spellfile = vim.fn.expand("~") .. "/.config/nvim/spell/de.utf-8.add"
    else
        vim.bo.spellfile = vim.fn.expand("~") .. "/.config/nvim/spell/en.utf-8.add"
    end
    vim.cmd.normal({ args = { "zg" }, bang = true })
end)
