local treesitter = {
    "nvim-treesitter/nvim-treesitter",
    cmd = {
        "TSInstall",
        "TSBufEnable",
        "TSBufDisable",
        "TSEnable",
        "TSDisable",
        "TSModuleInfo",
    },
}

local ts_parsers = {
    "markdown",
    "markdown_inline",
    "bash",
    "regex",
    "css",
    "scss",
    "typescript",
    "rust",
    "lua",
    "python",
    "query",
    "cpp",
    "yaml",
    "c",
    "vim",
    "latex",
    "java",
    "help",
    "julia",
    "vim",
    -- "norg",
    "zig",
    "diff",
}

treesitter.dependencies = {
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
}

treesitter.init = function()
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
end

treesitter.config = function()
    vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
            require("lazy").load({ plugins = { "nvim-treesitter-endwise" } })
        end,
    })
    local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()
    local colors = require("omega.colors").get()

    parser_configs.luap = {
        install_info = {
            url = "https://github.com/vhyrro/tree-sitter-luap",
            files = { "src/parser.c" },
            branch = "main",
            -- branch = "attached-modifiers",
        },
    }
    require("lazy").load({ plugins = { "playground" } })

    require("nvim-treesitter.configs").setup({
        ensure_installed = ts_parsers,
        highlight = {
            enable = true,
        },
        incremental_selection = {
            enable = true,

            keymaps = {
                init_selection = "gnn",
                node_incremental = "gnn",
                scope_incremental = "gns",
                node_decremental = "gnp",
            },
        },
        textsubjects = {
            enable = true,
            keymaps = {
                [","] = "textsubjects-smart",
            },
        },
        refactor = {
            highlight_definitions = { enable = false },
            highlight_current_scope = { enable = false },
            smart_rename = {
                enable = true,
                keymaps = {
                    smart_rename = "grr",
                },
            },
            navigation = {
                enable = true,
                keymaps = {
                    goto_definition = "gnd",
                    list_definitions = "gnD",
                    list_definitions_toc = "gO",
                    goto_next_usage = "gnu",
                    goto_previous_usage = "gpu",
                },
            },
        },
        playground = {
            enable = true,
            updatetime = 10,
            persist_queries = true,
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" },
        },
        endwise = { enable = true },
        indent = { enable = true, disable = { "python" } },
        rainbow = {
            enable = true,
            extended_mode = true,
            max_file_lines = 1000,
            colors = {
                colors.blue,
                colors.red,
                colors.green,
                colors.orange,
                colors.cyan,
                colors.pink,
            },
        },
        textobjects = {
            select = {
                enable = true,

                -- Automatically jump forward to textobj, similar to targets.vim
                lookahead = true,

                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["il"] = "@loop.inner",
                    ["al"] = "@loop.outer",
                    ["icd"] = "@conditional.inner",
                    ["acd"] = "@conditional.outer",
                    ["acm"] = "@comment.outer",
                    ["ast"] = "@statement.outer",
                    ["isc"] = "@scopename.inner",
                    ["iB"] = "@block.inner",
                    ["aB"] = "@block.outer",
                    ["p"] = "@parameter.inner",
                },
            },

            move = {
                enable = true,
                set_jumps = true, -- Whether to set jumps in the jumplist
                goto_next_start = {
                    ["gnf"] = "@function.outer",
                    ["gnif"] = "@function.inner",
                    ["gnp"] = "@parameter.inner",
                    ["gnc"] = "@call.outer",
                    ["gnic"] = "@call.inner",
                },
                goto_next_end = {
                    ["gnF"] = "@function.outer",
                    ["gniF"] = "@function.inner",
                    ["gnP"] = "@parameter.inner",
                    ["gnC"] = "@call.outer",
                    ["gniC"] = "@call.inner",
                },
                goto_previous_start = {
                    ["gpf"] = "@function.outer",
                    ["gpif"] = "@function.inner",
                    ["gpp"] = "@parameter.inner",
                    ["gpc"] = "@call.outer",
                    ["gpic"] = "@call.inner",
                },
                goto_previous_end = {
                    ["gpF"] = "@function.outer",
                    ["gpiF"] = "@function.inner",
                    ["gpP"] = "@parameter.inner",
                    ["gpC"] = "@call.outer",
                    ["gpiC"] = "@call.inner",
                },
            },
        },
    })
end

return treesitter
