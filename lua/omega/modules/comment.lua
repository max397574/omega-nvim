local comment = {
    "numToStr/Comment.nvim",
    keys = { "<leader>c", "gb" },
}

comment.config = function()
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
end

return comment
