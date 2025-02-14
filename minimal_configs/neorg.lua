vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

require("lazy.minit").repro({
    spec = {
        {
            "nvim-neorg/neorg",
            ft = "norg",
            opts = {
                load = {
                    ["core.defaults"] = {},
                },
            },
        },
        {
            "nvim-treesitter/nvim-treesitter",
            opts = {
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
                highlight = { enable = true },
            },
            config = function(_, opts)
                require("nvim-treesitter.configs").setup(opts)
            end,
        },
    },
})
