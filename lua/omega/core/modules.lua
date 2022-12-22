---@diagnostic disable: assign-type-mismatch
require("lazy").setup({
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("omega.modules.ui.blankline").configs["indent-blankline.nvim"]()
        end,
    },
    {
        "akinsho/bufferline.nvim",
        init = function()
            vim.api.nvim_create_autocmd({ "BufAdd", "TabEnter" }, {
                pattern = "*",
                group = vim.api.nvim_create_augroup("BufferLineLazyLoading", {}),
                callback = function()
                    local count = #vim.fn.getbufinfo({ buflisted = 1 })
                    if count >= 2 then
                        require("lazy").load({ plugins = { "bufferline.nvim" } })
                    end
                end,
            })
        end,
        config = function()
            require("omega.modules.ui.bufferline").configs["bufferline.nvim"]()
        end,
    },
    {
        "kyazdani42/nvim-web-devicons",
    },
    {
        "rebelot/heirline.nvim",
        lazy = false,
        -- event = "VeryLazy",
        config = function()
            require("omega.modules.ui.heirline").configs["heirline.nvim"]()
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        config = function()
            require("omega.modules.ui.noice").configs["noice.nvim"]()
        end,
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
            require("omega.modules.completion.annotations.configs")["neogen"]()
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = {
            "InsertEnter",
        },
        config = function()
            require("omega.modules.completion.autopairs").configs["nvim-autopairs"]()
        end,
    },
    {
        dir = "~/neovim_plugins/nvim-cmp",
        event = { "InsertEnter" },
        config = function()
            require("omega.modules.completion.cmp").configs["nvim-cmp"]()
        end,
        dependencies = {
            {
                "saadparwaiz1/cmp_luasnip",
            },
            {
                "hrsh7th/cmp-emoji",
            },
            {
                "hrsh7th/cmp-path",
            },
            {
                "kdheepak/cmp-latex-symbols",
            },
            {
                "hrsh7th/cmp-nvim-lua",
            },
            {
                "hrsh7th/cmp-nvim-lsp",
            },
        },
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
        "numToStr/Comment.nvim",
        keys = { "<leader>c", "gb" },
        config = function()
            require("omega.modules.misc.comment").configs["Comment.nvim"]()
        end,
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
        "lewis6991/gitsigns.nvim",
        init = function()
            vim.api.nvim_create_autocmd({ "BufRead" }, {
                group = vim.api.nvim_create_augroup("gitsign_load", {}),
                callback = function()
                    local function onexit(code, _)
                        if code == 0 then
                            vim.schedule(function()
                                require("lazy").load({ plugins = { "gitsigns.nvim" } })
                            end)
                        end
                    end
                    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                    if lines ~= { "" } then
                        vim.loop.spawn("git", {
                            args = {
                                "ls-files",
                                "--error-unmatch",
                                vim.fn.expand("%"),
                            },
                        }, onexit)
                    end
                end,
            })
        end,
        config = function()
            require("omega.modules.misc.gitsigns").configs["gitsigns.nvim"]()
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
        "ggandor/lightspeed.nvim",
        -- keys = { "S", "s", "f", "F" },
        -- init = function()
        --     vim.g.lightspeed_no_default_keymaps = true
        --     vim.keymap.set("n", "s", "<plug>Lightspeed_s")
        --     vim.keymap.set("n", "S", "<plug>Lightspeed_S")
        --     vim.keymap.set("n", "f", "<plug>Lightspeed_f")
        --     vim.keymap.set("n", "F", "<plug>Lightspeed_F")
        -- end,
        event = "VeryLazy",
        config = function()
            require("omega.modules.misc.lightspeed").configs["lightspeed.nvim"]()
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
        "nvim-neorg/neorg",
        ft = "norg",
        config = function()
            require("omega.modules.misc.neorg").configs["neorg"]()
        end,
        dependencies = {
            { dir = "~/neovim_plugins/neorg-telescope/" },
            {
                dir = "~/neovim_plugins/neorg-context/",
            },
            {
                dir = "~/neovim_plugins/neorg-kanban/",
            },
            {
                dir = "~/neovim_plugins/neorg-zettelkasten/",
            },
        },
        -- run = ":Neorg sync-parsers",
    },
    {
        "rktjmp/paperplanes.nvim",
        cmd = { "PP" },
        config = function()
            require("omega.modules.misc.paperplanes").configs["paperplanes.nvim"]()
        end,
    },
    {
        "kylechui/nvim-surround",
        keys = { "ys", "ds", "cs" },
        init = function()
            vim.keymap.set("v", "S", function()
                require("lazy").load({ plugins = { "nvim-surround" } })
                require("nvim-surround").visual_surround()
            end, {})
        end,
        config = function()
            require("omega.modules.misc.surround").configs["nvim-surround"]()
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        config = function()
            require("omega.modules.misc.telescope.configs")["telescope.nvim"]()
            vim.api.nvim_create_user_command("Telescope", function(opts)
                require("telescope.command").load_command(unpack(opts.fargs))
            end, {
                nargs = "*",
                complete = function(_, line)
                    local builtin_list = vim.tbl_keys(require("telescope.builtin"))
                    local extensions_list = vim.tbl_keys(require("telescope._extensions").manager)

                    local l = vim.split(line, "%s+")
                    local n = #l - 2

                    if n == 0 then
                        return vim.tbl_filter(function(val)
                            return vim.startswith(val, l[2])
                        end, vim.tbl_extend(
                            "force",
                            builtin_list,
                            extensions_list
                        ))
                    end

                    if n == 1 then
                        local is_extension = vim.tbl_filter(function(val)
                            return val == l[2]
                        end, extensions_list)

                        if #is_extension > 0 then
                            local extensions_subcommand_dict =
                                require("telescope.command").get_extensions_subcommand()
                            return vim.tbl_filter(function(val)
                                return vim.startswith(val, l[3])
                            end, extensions_subcommand_dict[l[2]])
                        end
                    end

                    local options_list = vim.tbl_keys(require("telescope.config").values)
                    return vim.tbl_filter(function(val)
                        return vim.startswith(val, l[#l])
                    end, options_list)
                end,
            })
        end,
        cmd = { "Telescope" },
        -- module = {
        --     "telescope",
        --     "omega.modules.misc.telescope",
        -- },
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
            },
            { dir = "~/neovim_plugins/lense.nvim" },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        keys = { "<leader>r", "<c-t>" },
        config = function()
            require("omega.modules.misc.toggleterm").configs["toggleterm.nvim"]()
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        init = function()
            if not vim.tbl_contains({ "[packer]", "" }, vim.fn.expand("%")) then
                require("lazy").load({ plugins = { "nvim-treesitter" } })
                require("lazy").load({ plugins = { "indent-blankline.nvim" } })
            else
                vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
                    callback = function()
                        local file = vim.fn.expand("%")
                        if not vim.tbl_contains({ "[packer]", "" }, file) then
                            require("lazy").load({ plugins = { "nvim-treesitter" } })
                            require("lazy").load({ plugins = { "indent-blankline.nvim" } })
                        end
                    end,
                })
            end
        end,
        cmd = {
            "TSInstall",
            "TSBufEnable",
            "TSBufDisable",
            "TSEnable",
            "TSDisable",
            "TSModuleInfo",
        },

        config = function()
            require("omega.modules.misc.treesitter").configs["nvim-treesitter"]()
        end,
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-refactor",
            },
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
            },
            {
                "RRethy/nvim-treesitter-endwise",
            },
            {
                "nvim-treesitter/playground",
            },
        },
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
}, {
    defaults = {
        lazy = true,
    },
    dev = {
        path = "~/neovim_plugins",
        patterns = { "max397574" },
    },
    performance = {
        rtp = {
            paths = {
                vim.fn.expand("~") .. "/.config/nvim",
            },
            disabled_plugins = {
                "loaded_python3_provider",
                "python_provider",
                "node_provider",
                "ruby_provider",
                "perl_provider",
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "tar",
                "tarPlugin",
                "rrhelper",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "logiPat",
                "netrwSettings",
                "netrwFileHandlers",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
                "load_ftplugin",
                "indent_on",
                "netrwPlugin",
                "tohtml",
                "man",
            },
        },
    },
})

return modules
