local swift_mod = {}

swift_mod.plugins = {
    ["xbase"] = {
        "xbase-lab/xbase",
        ft = "swift",
        requires = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
        },
    },
}

swift_mod.configs = {
    ["xbase"] = function()
        require("xbase").setup()
    end,
}

return swift_mod
