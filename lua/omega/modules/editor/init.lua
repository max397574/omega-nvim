return {
    {
        "max397574/better-escape.nvim",
        event = "VeryLazy",
        opts = {
            mappings = {
                t = {
                    j = { j = false },
                },
                i = {
                    h = {
                        h = "<esc>0i",
                    },
                    [" "] = {
                        ["<TAB>"] = function()
                            vim.defer_fn(function()
                                vim.o.ul = vim.o.ul
                                require("luasnip").expand_or_jump()
                            end, 1)
                        end,
                        ["<S-TAB>"] = function()
                            vim.defer_fn(function()
                                vim.o.ul = vim.o.ul
                                require("luasnip").jump(-1)
                            end, 1)
                        end,
                        [" "] = "<left>",
                    },
                },
            },
        },
    },
    {
        "folke/flash.nvim",
        opts = {
            jump = { autojump = true },
            modes = {
                char = { enabled = false },
                search = { enabled = false },
            },
            label = {
                current = true,
                before = true,
                after = false,
            },
            prompt = { prefix = { { " ", "FlashPromptIcon" } } },
        },
        config = function(_, opts)
            require("flash").setup(opts)
            vim.keymap.set("o", "r", function()
                require("flash").remote()
            end)
        end,
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump()
                end,
            },
        },
    },
    {
        "folke/trouble.nvim",
        cmd = { "Trouble" },
        opts = {},

        keys = {
            { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
            {
                "<leader>qp",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({ skip_groups = true, jump = true })
                    else
                        pcall(vim.cmd.cprev)
                    end
                end,
                desc = "Previous trouble/quickfix item",
            },
            {
                "<leader>qn",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        pcall(vim.cmd.cnext)
                    end
                end,
                desc = "Next trouble/quickfix item",
            },
        },
    },
    {
        "kylechui/nvim-surround",
        keys = { "ys", "ds", "cs" },
        init = function()
            vim.keymap.set("v", "S", function()
                require("nvim-surround").visual_surround()
            end, {})
        end,
        config = function(_, opts)
            require("nvim-surround").setup(opts)
            vim.api.nvim_set_hl(0, "NvimSurroundHighlight", { link = "CurSearch" })
        end,
    },
    { "MagicDuck/grug-far.nvim", opts = {}, cmd = { "GrugFar" } },
    require("omega.modules.editor.formatter"),
    require("omega.modules.editor.cmp"),
    require("omega.modules.editor.care"),
    require("omega.modules.editor.snippets"),
    require("omega.modules.editor.telescope"),
    require("omega.modules.editor.treesitter"),
    require("omega.modules.editor.which_key"),
    require("omega.modules.editor.terminal"),
}
