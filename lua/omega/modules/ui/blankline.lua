local blankline = {}

blankline.plugins = {
    ["indent-blankline.nvim"] = {},
}

blankline.configs = {
    ["indent-blankline.nvim"] = function()
        vim.g.indentLine_enabled = 1
        require("indent_blankline").setup({
            buftype_exclude = { "terminal", "nofile" },
            filetype_exclude = {
                "help",
                "startify",
                "dashboard",
                "packer",
                "neogitstatus",
                "norg",
                "NvimTree",
                "Trouble",
            },
            char = "▏",
            show_trailing_blankline_indent = false,
            show_first_indent_level = false,
            use_treesitter = true,
            show_current_context = true,
            context_patterns = {
                "class",
                "return",
                "function",
                "method",
                "^if",
                "^do",
                "^switch",
                "^while",
                "jsx_element",
                "^for",
                "^object",
                "^table",
                "block",
                "arguments",
                "if_statement",
                "else_clause",
                "jsx_element",
                "jsx_self_closing_element",
                "try_statement",
                "catch_clause",
                "import_statement",
                "operation_type",
            },
        })
        -- HACK: work-around for https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
        vim.wo.colorcolumn = "99999"
        local colors = require("omega.colors").get()

        vim.api.nvim_set_hl(0, "IndentBlanklineChar", { fg = colors.grey_fg })
        vim.api.nvim_set_hl(0, "IndentBlanklineContextChar", { fg = colors.red })
    end,
}

return blankline
