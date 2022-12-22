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
    {
        dir = "~/neovim_plugins/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("omega.modules.mappings.which_key").configs["which-key.nvim"]()
            require("omega.core.mappings")
        end,
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
        dir = "~/neovim_plugins/neocomplete.nvim/",
        event = "InsertEnter",
        config = function()
            require("omega.modules.completion.neocomplete").configs["neocomplete.nvim"]()
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
        "mhartington/formatter.nvim",
        cmd = { "FormatWrite", "Format", "FormatLock" },
        config = function()
            require("omega.modules.misc.formatter.configs")["formatter.nvim"]()
        end,
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
        "Krafi2/jeskape.nvim",
        event = "InsertEnter",
        config = function()
            require("omega.modules.misc.insert_utils").configs["jeskape.nvim"]()
        end,
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
            require("omega.modules.misc.paperplanes").configs["paperplanes.nvim"]()
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
