local comment = {}

comment.configs = {
    ["Comment.nvim"] = function()
        require("comment").setup({
            toggler = {
                ---line-comment keymap
                line = "<leader>cc",
                ---block-comment keymap
                block = "gbc",
            },

            ---LHS of operator-pending mappings in NORMAL + VISUAL mode
            opleader = {
                ---line-comment keymap
                line = "<leader>c",
                ---block-comment keymap
                block = "gb",
            },
            mappings = {
                -- extended = true,
            },
        })
    end,
}

return comment
