return {
    { "nvim-tree/nvim-web-devicons" },
    { "rcarriga/nvim-notify" },
    { "MunifTanjim/nui.nvim" },
    { "nvim-lua/plenary.nvim" },

    {
        "danymat/neogen",
        config = function()
            require("neogen").setup({
                snippet_engine = "luasnip",
                enabled = true,
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("omega.modules.completion.snippets").configs["LuaSnip"]()
        end,
        dependencies = {
            {
                dir = "~/neovim_plugins/friendly-snippets",
                event = "InsertEnter",
            },
        },
    },
    {
        enabled = false,
        dir = "~/neovim_plugins/neocomplete.nvim/",
        event = "InsertEnter",
        config = function()
            require("neocomplete").setup()
        end,
    },
    {
        "xiyaowong/nvim-colorizer.lua",
        cmd = { "ColorizerAttachToBuffer" },
        config = function()
            require("colorizer").setup({
                "*",
            }, {
                mode = "foreground",
                hsl_fn = true,
            })
            vim.cmd.ColorizerAttachToBuffer()
        end,
    },
    {
        dir = "~/neovim_plugins/colorscheme_switcher/",
    },
    {
        "ruifm/gitlinker.nvim",
        keys = { "<leader>gy" },
        init = function()
            vim.keymap.set("x", "<leader>gy", function()
                require("gitlinker").get_buf_range_url("v")
            end)
        end,
        config = function()
            require("gitlinker").setup({ mappings = nil })
        end,
    },
    {
        "nanotee/luv-vimdocs",
        -- cmd = { "Telescope", "h" },
        cmd = { "Telescope" },
    },
    {
        "jbyuki/nabla.nvim",
        ft = {
            "tex",
            "norg",
        },
    },
    {
        "rktjmp/paperplanes.nvim",
        cmd = { "PP" },
        config = function()
            require("paperplanes").setup({
                register = "+",
                provider = "paste.rs",
            })
        end,
    },
    {
        dir = "~/neovim_plugins/nvim-treehopper/",
    },
    {
        "folke/trouble.nvim",
        cmd = {
            "Trouble",
            "TroubleClose",
            "TroubleToggle",
            "TroubleRefresh",
            "TodoTrouble",
        },
        config = function()
            require("trouble").setup()
        end,
    },
    { "cshuaimin/ssr.nvim" },
    { "elihunter173/dirbuf.nvim", cmd = "Dirbuf" },
    { dir = "~/neovim_plugins/neo-news.nvim" },
    {
        dir = "~/neovim_plugins/tomato.nvim",
        config = true,
        lazy = false,
        enabled = false,
    },
    {
        "stevearc/oil.nvim",
        cmd = "Oil",
        config = {
            win_options = {
                conceallevel = 0,
            },
            float = {
                win_options = {
                    winblend = 0,
                },
            },
        },
    },
    {
        dir = "~/neovim_plugins/tmpfile.nvim/",
        config = function()
            require("tmpfile").setup()
        end,
        cmd = "Tmp",
    },
    {
        dir = "~/neovim_plugins/vim-apm",
        cmd = "VimApm",
    },
    {
        "LunarVim/lunar.nvim",
    },
    { "folke/tokyonight.nvim", enbaled = false },
}
