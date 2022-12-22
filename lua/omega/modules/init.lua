return {
    {
        "nvim-tree/nvim-web-devicons",
    },
    {
        "rcarriga/nvim-notify",
    },
    {
        "MunifTanjim/nui.nvim",
    },
    { "nvim-lua/plenary.nvim" },
    {
        "neovim/nvim-lspconfig",
        config = function()
            require("omega.modules.langs.main").configs["nvim-lspconfig"]()
            require("omega.modules.langs.html")
        end,
        dependencies = {
            {
                "folke/neodev.nvim",
                config = function()
                    require("omega.modules.langs.lua").configs["neodev.nvim"]()
                end,
            },
            {
                "simrat39/rust-tools.nvim",
                config = function()
                    require("omega.modules.langs.rust").configs["rust-tools.nvim"]()
                end,
            },
        },
        event = "BufReadPre",
    },

    {
        "mfussenegger/nvim-dap",
        config = function()
            require("omega.modules.langs.debugging").configs["nvim-dap"]()
        end,
        dependencies = {
            {
                "theHamsta/nvim-dap-virtual-text",
            },
            {
                "jbyuki/one-small-step-for-vimkind",
            },
        },
    },
    {
        "rcarriga/nvim-dap-ui",
        config = function()
            require("omega.modules.langs.debugging").configs["nvim-dap-ui"]()
        end,
    },
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
            require("omega.modules.misc.colorizer").configs["nvim-colorizer.lua"]()
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
        "akinsho/toggleterm.nvim",
        keys = { "<leader>r", "<c-t>" },
        config = function()
            require("omega.modules.misc.toggleterm").configs["toggleterm.nvim"]()
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
            require("omega.modules.misc.trouble.configs")["trouble.nvim"]()
        end,
    },
    { "cshuaimin/ssr.nvim" },
    { "elihunter173/dirbuf.nvim", cmd = "Dirbuf" },
}
