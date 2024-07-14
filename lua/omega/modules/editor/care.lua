return {
    "max397574/care.nvim",
    enabled = require("omega.config").modules.completion == "care",
    -- event = "InsertEnter",
    lazy = false,
    dependencies = {
        "max397574/care-lsp",
        { "max397574/care-cmp" },
        "max397574/cmp-greek",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-path",
    },
    config = function()
        vim.keymap.set("i", "<c-n>", function()
            vim.snippet.jump(1)
        end)
        vim.keymap.set("i", "<c-p>", function()
            vim.snippet.jump(-1)
        end)
        vim.keymap.set("i", "<c-space>", function()
            require("care").api.complete()
        end)

        vim.keymap.set("i", "<c-f>", function()
            if require("care").api.doc_is_open() then
                require("care").api.scroll_docs(4)
            elseif require("luasnip").choice_active() then
                require("luasnip").change_choice(1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
            end
        end)

        vim.keymap.set("i", "<c-d>", function()
            if require("care").api.doc_is_open() then
                require("care").api.scroll_docs(-4)
            elseif require("luasnip").choice_active() then
                require("luasnip").change_choice(-1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
            end
        end)

        vim.keymap.set("i", "<cr>", "<Plug>(CareConfirm)")
        vim.keymap.set("i", "<c-e>", "<Plug>(CareClose)")
        vim.keymap.set("i", "<c-j>", "<Plug>(CareSelectNext)")
        vim.keymap.set("i", "<c-k>", "<Plug>(CareSelectPrev)")

        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                require("care").core.menu:close()
            end,
        })
    end,
}
