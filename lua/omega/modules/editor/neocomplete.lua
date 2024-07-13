return {
    "max397574/neocomplete.nvim",
    enabled = require("omega.config").modules.completion == "neocomplete",
    event = "InsertEnter",
    dependencies = { "max397574/neocomplete-lsp" },
    config = function()
        vim.keymap.set("i", "<c-n>", function()
            vim.snippet.jump(1)
        end)
        vim.keymap.set("i", "<c-p>", function()
            vim.snippet.jump(-1)
        end)
        vim.keymap.set("i", "<c-space>", function()
            require("neocomplete").api.complete()
        end)

        local luasnip = require("luasnip")

        vim.keymap.set("i", "<c-f>", function()
            if require("neocomplete").api.doc_is_open() then
                require("neocomplete").api.scroll_docs(4)
            elseif luasnip.choice_active() then
                require("luasnip").change_choice(1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
            end
        end)

        vim.keymap.set("i", "<c-d>", function()
            if require("neocomplete").api.doc_is_open() then
                require("neocomplete").api.scroll_docs(-4)
            elseif luasnip.choice_active() then
                require("luasnip").change_choice(-1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
            end
        end)

        vim.keymap.set("i", "<cr>", "<Plug>(NeocompleteConfirm)")
        vim.keymap.set("i", "<c-e>", "<Plug>(NeocompleteClose)")
        vim.keymap.set("i", "<c-j>", "<Plug>(NeocompleteSelectNext)")
        vim.keymap.set("i", "<c-k>", "<Plug>(NeocompleteSelectPrev)")

        vim.api.nvim_create_autocmd("InsertLeave", {
            callback = function()
                require("neocomplete").core.menu:close()
            end,
        })
    end,
}
