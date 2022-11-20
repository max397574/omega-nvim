local modules = {}
function modules.bootstrap_packer()
    local has_packer = pcall(require, "packer")
    if not has_packer then
        -- Packer Bootstrapping
        local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
        if vim.fn.isdirectory(packer_path) == 0 then
            vim.notify("Bootstrapping packer.nvim, please wait ...")
            vim.fn.system({
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                packer_path,
            })
        end

        vim.cmd.packadd("packer.nvim")
    end
end
local module_sections = {
    ["ui"] = {
        ["blankline"] = {
            {
                "lukas-reineke/indent-blankline.nvim",
                opt = true,
                setup = function()
                    vim.defer_fn(function()
                        require("packer").loader("indent-blankline.nvim")
                    end, 0)
                end,
                config = function()
                    require("omega.modules.ui.blankline").configs["indent-blankline.nvim"]()
                end,
            },
        },
        ["bufferline"] = {
            {
                "akinsho/bufferline.nvim",
                opt = true,
                setup = function()
                    vim.api.nvim_create_autocmd({ "BufAdd", "TabEnter" }, {
                        pattern = "*",
                        group = vim.api.nvim_create_augroup("BufferLineLazyLoading", {}),
                        callback = function()
                            local count = #vim.fn.getbufinfo({ buflisted = 1 })
                            if count >= 2 then
                                vim.cmd.PackerLoad("bufferline.nvim")
                            end
                        end,
                    })
                end,
                config = function()
                    require("omega.modules.ui.bufferline").configs["bufferline.nvim"]()
                end,
            },
        },
        ["devicons"] = {
            {
                "kyazdani42/nvim-web-devicons",
                module = "nvim-web-devicons",
            },
        },
        ["heirline"] = {
            {
                "rebelot/heirline.nvim",
                config = function()
                    require("omega.modules.ui.heirline").configs["heirline.nvim"]()
                end,
            },
            {
                "SmiteshP/nvim-navic",
                ft = {
                    "python",
                    "html",
                    "typescript",
                    "zig",
                    "css",
                    "nix",
                    "rust",
                    "haskell",
                    "tex",
                    "vim",
                    "lua",
                },
                config = function()
                    require("omega.modules.ui.heirline").configs["nvim-navic"]()
                end,
            },
        },
        ["noice"] = {
            {
                "folke/noice.nvim",
                opt = true,
                setup = function()
                    vim.defer_fn(function()
                        require("packer").loader("noice.nvim")
                    end, 1000)
                end,
                config = function()
                    require("omega.modules.ui.noice").configs["noice.nvim"]()
                end,
            },
            {
                "rcarriga/nvim-notify",
                module = "notify",
            },
            {
                "MunifTanjim/nui.nvim",
                module = { "nui" },
            },
        },
    },
    ["mappings"] = {
        ["which_key"] = {
            {
                "~/neovim_plugins/which-key.nvim",
                config = function()
                    require("omega.modules.mappings.which_key").configs["which-key.nvim"]()
                    require("omega.core.mappings")
                end,
            },
        },
    },
    ["core"] = {
        ["omega"] = {
            { "nvim-lua/plenary.nvim", module = "plenary" },
            {
                "wbthomason/packer.nvim",
                cmd = {
                    "PackerSnapshot",
                    "PackerSnapshotRollback",
                    "PackerSnapshotDelete",
                    "PackerInstall",
                    "PackerUpdate",
                    "PackerSync",
                    "PackerClean",
                    "PackerCompile",
                    "PackerStatus",
                    "PackerProfile",
                    "PackerLoad",
                },
            },
            { "lewis6991/impatient.nvim" },
        },
    },
    ["langs"] = {
        lua = {
            {
                "folke/neodev.nvim",
                ft = "lua",
                config = function()
                    require("omega.modules.langs.lua").configs["neodev.nvim"]()
                end,
            },
        },
        -- log = {
        --     { "MTDL9/vim-log-highlighting", ft = "log" },
        -- },
        main = {
            {
                "neovim/nvim-lspconfig",
                config = function()
                    require("omega.modules.langs.main").configs["nvim-lspconfig"]()
                    require("omega.modules.langs.html")
                end,
                opt = true,
                ft = {
                    "python",
                    "html",
                    "typescript",
                    "zig",
                    "rust",
                    "css",
                    "cpp",
                    "nix",
                    "julia",
                    "rust",
                    "haskell",
                    "tex",
                    "vim",
                    "lua",
                    "tangle",
                },
            },

            -- {
            --     "ray-x/lsp_signature.nvim",
            --     after = "nvim-lspconfig",
            --     config = function()
            --         require("omega.modules.langs.main").configs["lsp_signature.nvim"]()
            --     end,
            -- },
        },
        -- python,
        rust = {
            {
                "simrat39/rust-tools.nvim",
                ft = "rust",
                config = function()
                    require("omega.modules.langs.rust").configs["rust-tools.nvim"]()
                end,
            },
        },
        -- swift,
        debugging = {
            {
                "mfussenegger/nvim-dap",
                opt = true,
                module = "dap",
                config = function()
                    require("omega.modules.langs.debugging").configs["nvim-dap"]()
                end,
            },
            {
                "rcarriga/nvim-dap-ui",
                opt = true,
                config = function()
                    require("omega.modules.langs.debugging").configs["nvim-dap-ui"]()
                end,
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                after = "nvim-dap",
            },
            {
                "jbyuki/one-small-step-for-vimkind",
                after = "nvim-dap",
            },
        },
    },
    ["completion"] = {
        annotations = {
            {
                "danymat/neogen",
                module = { "neogen" },
                requires = { "LuaSnip" },
                config = function()
                    require("omega.modules.completion.annotations.configs")["neogen"]()
                end,
            },
        },
        autopairs = {
            {
                "windwp/nvim-autopairs",
                event = {
                    "InsertEnter",
                },
                after = "nvim-cmp",
                config = function()
                    require("omega.modules.completion.autopairs").configs["nvim-autopairs"]()
                end,
            },
        },
        cmp = {
            {
                "~/neovim_plugins/nvim-cmp",
                requires = { "nvim-autopairs" },
                event = { "InsertEnter", "CmdLineEnter" },
                config = function()
                    require("omega.modules.completion.cmp").configs["nvim-cmp"]()
                end,
            },
            {
                "saadparwaiz1/cmp_luasnip",
                after = "nvim-cmp",
            },
            {
                "hrsh7th/cmp-emoji",
                after = "nvim-cmp",
            },
            -- {
            --     "max397574/cmp-greek",
            --     after = "nvim-cmp",
            -- },
            -- {
            --     "hrsh7th/cmp-buffer",
            --     after = "nvim-cmp",
            -- },
            {
                "hrsh7th/cmp-path",
                after = "nvim-cmp",
            },
            {
                "kdheepak/cmp-latex-symbols",
                after = "nvim-cmp",
            },
            -- {
            --     "hrsh7th/cmp-calc",
            --     after = "nvim-cmp",
            -- },
            {
                "hrsh7th/cmp-nvim-lua",
                after = "nvim-cmp",
            },
            {
                "hrsh7th/cmp-nvim-lsp",
                after = "nvim-cmp",
            },
            -- {
            --     "hrsh7th/cmp-cmdline",
            --     after = "nvim-cmp",
            -- },
            -- {
            --     "dmitmel/cmp-cmdline-history",
            --     after = "nvim-cmp",
            -- },
            -- {
            --     "rcarriga/cmp-dap",
            --     after = "nvim-cmp",
            -- },
        },
        snippets = {
            {
                "L3MON4D3/LuaSnip",
                module = "luasnip",
                config = function()
                    require("omega.modules.completion.snippets").configs["LuaSnip"]()
                end,
            },
            {
                "~/neovim_plugins/friendly-snippets",
                event = "InsertEnter",
                after = "LuaSnip",
            },
        },
        neocomplete = {
            {
                "~/neovim_plugins/neocomplete.nvim/",
                config = function()
                    require("omega.modules.completion.neocomplete").configs["neocomplete.nvim"]()
                end,
            },
        },
    },
    ["misc"] = {
        colorizer = {
            {
                "xiyaowong/nvim-colorizer.lua",
                cmd = { "ColorizerAttachToBuffer" },
                config = function()
                    require("omega.modules.misc.colorizer").configs["nvim-colorizer.lua"]()
                end,
            },
        },
        colorscheme_switcher = {
            {
                "~/neovim_plugins/colorscheme_switcher/",
                module = { "colorscheme_switcher" },
            },
        },
        -- colortils = {
        --     {
        --         "~/neovim_plugins/colortils.nvim/",
        --         cmd = "Colortils",
        --         config = function()
        --             require("omega.modules.misc.colortils").configs["colortils.nvim"]()
        --         end,
        --     },
        -- },
        comment = {
            {
                "numToStr/Comment.nvim",
                keys = { "<leader>c", "gb" },
                config = function()
                    require("omega.modules.misc.comment").configs["Comment.nvim"]()
                end,
            },
        },
        -- "dynamic_help",
        formatter = {
            {
                "mhartington/formatter.nvim",
                cmd = { "FormatWrite", "Format", "FormatLock" },
                config = function()
                    require("omega.modules.misc.formatter.configs")["formatter.nvim"]()
                end,
            },
        },
        gitlinker = {
            {
                "ruifm/gitlinker.nvim",
                keys = { "<leader>gy" },
                config = function()
                    require("gitlinker").setup()
                end,
            },
        },
        gitsigns = {
            {
                "lewis6991/gitsigns.nvim",
                opt = true,
                setup = function()
                    vim.api.nvim_create_autocmd({ "BufRead" }, {
                        group = vim.api.nvim_create_augroup("gitsign_load", {}),
                        callback = function()
                            vim.fn.system("git -C " .. vim.fn.expand("%:p:h") .. " rev-parse")
                            if vim.v.shell_error == 0 then
                                vim.api.nvim_del_augroup_by_name("gitsign_load")
                                vim.schedule(function()
                                    require("packer").loader("gitsigns.nvim")
                                end)
                            end
                        end,
                    })
                end,
                config = function()
                    require("omega.modules.misc.gitsigns").configs["gitsigns.nvim"]()
                end,
            },
        },
        harpoon = {
            {
                "ThePrimeagen/harpoon",
                keys = { "<leader>H" },
                config = function()
                    require("telescope").load_extension("harpoon")
                end,
            },
        },
        help_files = {
            {
                "nanotee/luv-vimdocs",
                cmd = { "Telescope", "h" },
            },
            -- {
            --     "milisims/nvim-luaref",
            --     cmd = { "Telescope", "h" },
            -- },
            -- {
            --     "~/neovim_plugins/help_files/",
            --     cmd = { "Telescope", "h" },
            -- },
            -- {
            --     "~/neovim_plugins/crefvim/",
            --     cmd = { "Telescope", "h" },
            -- },
        },
        -- holo = {
        --     {
        --         "edluffy/hologram.nvim",
        --         module = "hologram",
        --         config = function()
        --             require("hologram").setup()
        --         end,
        --     },
        -- },
        -- image = {
        --     {
        --         "samodostal/image.nvim",
        --         setup = function()
        --             vim.api.nvim_create_autocmd({ "BufEnter", "VimResized" }, {
        --                 pattern = {
        --                     "*.jpeg",
        --                     "*.jpg",
        --                     "*.png",
        --                     "*.bmp",
        --                     "*.webp",
        --                     "*.tiff",
        --                     "*.tif",
        --                 },
        --                 once = true,
        --                 callback = function()
        --                     require("packer").loader("image.nvim")
        --                     vim.cmd.PackerLoad("baleia.nvim")
        --                     require("image").setup({
        --                         render = {
        --                             foreground_color = true,
        --                             background_color = true,
        --                         },
        --                     })
        --                     local async = require("plenary.async")
        --                     local config = require("image.config")
        --                     local ui = require("image.ui")
        --                     local dimensions = require("image.dimensions")
        --                     local api = require("image.api")
        --                     local options = require("image.options")
        --                     local global_opts = nil
        --                     local on_image_open = function()
        --                         local buf_id = 0
        --                         local buf_path = vim.api.nvim_buf_get_name(buf_id)
        --
        --                         local ascii_width, ascii_height, horizontal_padding, vertical_padding =
        --                             dimensions.calculate_ascii_width_height(
        --                                 buf_id,
        --                                 buf_path,
        --                                 global_opts
        --                             )
        --
        --                         options.set_options_before_render(buf_id)
        --                         ui.buf_clear(buf_id)
        --
        --                         local label =
        --                             ui.create_label(buf_path, ascii_width, horizontal_padding)
        --
        --                         local ascii_data = api.get_ascii_data(
        --                             buf_path,
        --                             ascii_width,
        --                             ascii_height,
        --                             global_opts
        --                         )
        --                         ui.buf_insert_data_with_padding(
        --                             buf_id,
        --                             ascii_data,
        --                             horizontal_padding,
        --                             vertical_padding,
        --                             label,
        --                             global_opts
        --                         )
        --
        --                         options.set_options_after_render(buf_id)
        --                     end
        --                     global_opts = config.DEFAULT_OPTS
        --
        --                     async.run(on_image_open, function() end)
        --                 end,
        --             })
        --         end,
        --         opt = true,
        --     },
        --     { "m00qek/baleia.nvim", opt = true },
        -- },
        insert_utils = {
            {
                "Krafi2/jeskape.nvim",
                event = "InsertEnter",
                config = function()
                    require("omega.modules.misc.insert_utils").configs["jeskape.nvim"]()
                end,
            },
        },
        lightspeed = {
            {
                "ggandor/lightspeed.nvim",
                keys = { "S", "s", "f", "F" },
                setup = function()
                    vim.g.lightspeed_no_default_keymaps = true
                    vim.keymap.set("n", "s", "<plug>Lightspeed_s")
                    vim.keymap.set("n", "S", "<plug>Lightspeed_S")
                    vim.keymap.set("n", "f", "<plug>Lightspeed_f")
                    vim.keymap.set("n", "F", "<plug>Lightspeed_F")
                end,
                config = function()
                    require("omega.modules.misc.lightspeed").configs["lightspeed.nvim"]()
                end,
            },
        },
        -- mkdir = {
        --     {
        --         "jghauser/mkdir.nvim",
        --         event = "BufWritePre",
        --         config = function()
        --             require("mkdir")
        --         end,
        --     },
        -- },
        nabla = {
            {
                "jbyuki/nabla.nvim",
                ft = {
                    "tex",
                    "norg",
                },
            },
        },
        neorg = {
            {
                "nvim-neorg/neorg",
                -- "~/neovim_plugins/neorg",
                ft = "norg",
                setup = function()
                    vim.filetype.add({
                        extension = {
                            norg = "norg",
                        },
                    })
                end,
                config = function()
                    require("omega.modules.misc.neorg").configs["neorg"]()
                end,
                -- run = ":Neorg sync-parsers",
            },
            { "~/neovim_plugins/neorg-telescope/", after = "neorg" },
            {
                "~/neovim_plugins/neorg-context/",
                after = "neorg",
                config = function()
                    neorg.modules.load_module("external.context", nil, {})
                end,
            },
            {
                "~/neovim_plugins/neorg-kanban/",
                after = "neorg",
                config = function()
                    neorg.modules.load_module("external.kanban", nil, {})
                end,
            },
            {
                "~/neovim_plugins/neorg-zettelkasten/",
                after = "neorg",
                config = function()
                    neorg.modules.load_module("external.zettelkasten", nil, {})
                end,
            },
        },
        -- ["nvim-tree"] = {
        --     {
        --         "kyazdani42/nvim-tree.lua",
        --         cmd = { "NvimTreeToggle", "NvimTreeOpen" },
        --         config = function()
        --             require("omega.modules.misc.nvim-tree").configs["nvim-tree.lua"]()
        --         end,
        --     },
        -- },
        paperplanes = {
            {
                "rktjmp/paperplanes.nvim",
                cmd = { "PP" },
                config = function()
                    require("omega.modules.misc.paperplanes").configs["paperplanes.nvim"]()
                end,
            },
        },
        -- sj = {
        --     {
        --         "woosaaahh/sj.nvim",
        --         keys = { "/" },
        --         config = function()
        --             require("omega.modules.misc.sj").configs["sj.nvim"]()
        --         end,
        --     },
        -- },
        surround = {
            {
                "kylechui/nvim-surround",
                keys = { "ys", "ds", "cs" },
                setup = function()
                    vim.keymap.set("v", "S", function()
                        require("packer").loader("nvim-surround")
                        require("nvim-surround").visual_surround()
                    end, {})
                end,
                module = "nvim-surround",
                config = function()
                    require("omega.modules.misc.surround").configs["nvim-surround"]()
                end,
            },
        },
        -- symbols_outline = {
        --     {
        --         "simrat39/symbols-outline.nvim",
        --         cmd = "SymbolsOutline",
        --         config = function()
        --             require("omega.modules.misc.symbols_outline").configs["symbols-outline.nvim"]()
        --         end,
        --     },
        -- },
        telescope = {
            {
                "nvim-telescope/telescope.nvim",
                config = function()
                    require("omega.modules.misc.telescope.configs")["telescope.nvim"]()
                end,
                cmd = { "Telescope" },
                setup = function()
                    -- vim.defer_fn(function()
                    --     vim.cmd.PackerLoad("telescope.nvim")
                    -- end, 0)
                end,
                module = {
                    "telescope",
                    "omega.modules.misc.telescope",
                },
            },
            {
                "xiyaowong/telescope-emoji.nvim",
                config = function()
                    require("omega.modules.misc.telescope.configs")["telescope-emoji.nvim"]()
                end,
                after = "telescope.nvim",
            },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
                after = "telescope.nvim",
            },
            { "nvim-telescope/telescope-symbols.nvim", after = "telescope.nvim" },
            {
                "nvim-telescope/telescope-file-browser.nvim",
                after = "telescope.nvim",
            },
            -- {
            --     "nvim-telescope/telescope-ui-select.nvim",
            --     after = "telescope.nvim",
            --     opt = true,
            --     setup = function()
            --         omega.ui_select = vim.ui.select
            --         vim.ui.select = function(items, opts, on_choice)
            --             vim.cmd.PackerLoad({
            --                 "telescope.nvim",
            --                 "telescope-ui-select.nvim",
            --             })
            --             vim.ui.select(items, opts, on_choice)
            --         end
            --     end,
            -- },
            { "~/neovim_plugins/lense.nvim", after = "telescope.nvim" },
        },
        todo = {
            {
                "folke/todo-comments.nvim",
                cmd = { "TodoTrouble", "TodoTelescope", "TodoQuickFix", "TodoLocList" },
                config = function()
                    require("omega.modules.misc.todo").configs["todo-comments.nvim"]()
                end,
            },
        },
        toggleterm = {
            {
                "akinsho/toggleterm.nvim",
                keys = { "<leader>r", "<c-t>" },
                module = { "toggleterm" },
                config = function()
                    require("omega.modules.misc.toggleterm").configs["toggleterm.nvim"]()
                end,
            },
        },
        -- "tomato",
        treesitter = {
            {
                "nvim-treesitter/nvim-treesitter",
                config = function()
                    require("omega.modules.misc.treesitter").configs["nvim-treesitter"]()
                end,
            },
            {
                "nvim-treesitter/nvim-treesitter-refactor",
                opt = true,
                setup = function()
                    vim.defer_fn(function()
                        require("packer").loader("nvim-treesitter-refactor")
                    end, 1)
                end,
                after = "nvim-treesitter",
            },
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                opt = true,
                setup = function()
                    vim.defer_fn(function()
                        require("packer").loader("nvim-treesitter-textobjects")
                    end, 1)
                end,
                after = "nvim-treesitter",
            },
            {
                "RRethy/nvim-treesitter-endwise",
                opt = true,
            },
            {
                "p00f/nvim-ts-rainbow",
            },
            {
                "nvim-treesitter/playground",
                cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
            },
            {
                "~/neovim_plugins/nvim-treehopper/",
                module = "tsht",
            },
            {
                "ziontee113/query-secretary",
                keys = { "<leader>qw" },
            },
        },
        trouble = {
            {
                "folke/trouble.nvim",
                module = "trouble",
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
        },
        -- undotree = {
        --     {
        --         "mbbill/undotree",
        --         cmd = "UndotreeToggle",
        --     },
        -- },
        venn = {
            {
                "jbyuki/venn.nvim",
                cmd = { "VBox", "VBoxH", "VBoxD", "VBoxHO", "VBoxDO" },
            },
        },
        -- "windows",
    },
    refactoring = {
        ssr = {
            { "cshuaimin/ssr.nvim", module = "ssr" },
        },
    },
    games = {
        vimbegood = {
            {
                "~/neovim_plugins/vim-be-good",
                cmd = "VimBeGood",
                config = function()
                    require("vim-be-good").setup()
                end,
            },
        },
        wordle = {
            { "n-shift/wordle.nvim", cmd = "Wordle" },
        },
    },
}
function modules.setup()
    local packer = require("packer")
    packer.init({
        -- compile_path = vim.fn.stdpath("data") .. "/plugin/packer_compiled.lua",
        git = {
            clone_timeout = 300,
            subcommands = {
                -- Prevent packer from downloading all branches metadata to reduce cloning cost
                -- for heavy size plugins like plenary (removed the '--no-single-branch' git flag)
                install = "clone --depth %i --progress",
            },
        },
        max_jobs = 10,
        display = {
            done_sym = "",
            error_syn = "×",
            open_fn = function()
                return require("packer.util").float({
                    border = require("omega.utils").border(),
                })
            end,
            keybindings = {
                toggle_info = "<TAB>",
            },
        },
        profile = {
            enable = true,
        },
        snapshot = "stable",
    })

    packer.reset()
end

function modules.load()
    local use = require("packer").use
    for sec, sec_modules in pairs(module_sections) do
        for mod_sec, module in pairs(sec_modules) do
            if type(module) == "string" then
                local keybindings = require(("omega.modules.%s.%s"):format(sec, module)).keybindings
                if keybindings then
                    keybindings()
                end
            end
            if type(mod_sec) == "string" then
                local keybindings =
                    require(("omega.modules.%s.%s"):format(sec, mod_sec)).keybindings
                if keybindings then
                    keybindings()
                end
            end
            for _, mod in ipairs(module) do
                use(mod)
            end
        end
    end
end

return modules
