local which_key = {}

which_key.plugins = {
    ["which-key.nvim"] = {
        "~/neovim_plugins/which-key.nvim",
    },
}

which_key.configs = {
    ["which-key.nvim"] = function()
        require("which-key").setup({
            show_help = false,
            layout = {
                height = { max = 20 },
                spacing = 3, -- spacing between columns
            },
            ignore_missing = true,
            window = {
                border = require("omega.utils").border(),
                margin = { 1, 0, 1, 0 }, -- top right bottom left
                padding = { 0, 2, 0, 0 }, -- top right bottom left
                winblend = 0,
            },
            icons = {
                group = " ",
                label = " ",
            },
        })

        vim.api.nvim_set_hl(0, "WhichKeyFloat", { link = "Special" })
        vim.api.nvim_set_hl(0, "WhichKey", { link = "Special" })
    end,
}

return which_key
