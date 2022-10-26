local comment = {}

comment.plugins = {
    ["Comment.nvim"] = {
        "numToStr/Comment.nvim",
        keys = { "<leader>c", "gb" },
    },
}

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

comment.keybindings = function()
    local wk = require("which-key")
    wk.register({

        c = {
            name = " Comment",
            c = { "Toggle Line" },
        },
    }, {
        prefix = "<leader>",
        mode = "n",
    })
end

return comment
