return {
    {
        "max397574/better-escape.nvim",
        event = "VeryLazy",
        opts = {
            mappings = {
                t = {
                    j = { j = false },
                },
                v = {
                    j = { k = false },
                },
                s = {
                    j = { k = false },
                },
                i = {
                    [" "] = {
                        ["<TAB>"] = function()
                            vim.defer_fn(function()
                                vim.o.ul = vim.o.ul
                                require("luasnip").expand()
                            end, 1)
                        end,
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
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end },
            "d",
            "y"
        },
    },
    {
        -- TODO: perhaps eventually switch back to non-forked one
        -- "folke/trouble.nvim",
        "h-michael/trouble.nvim",
        branch = "fix/decoration-provider-api",
        cmd = { "Trouble" },
        opts = {},

        ---@type trouble.Mode

        keys = {
            {
                "<leader>xX",
                -- "<cmd>Trouble diagnostics open<cr>",
                function()
                    require("trouble").toggle({ mode = "diagnostics" })
                end,
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xx",
                function()
                    require("trouble").toggle({ mode = "diagnostics", filter = { buf = 0 } })
                end,
                desc = "Buffer Diagnostics (Trouble)",
            },
            { "<leader>xl", "<cmd>Trouble loclist open<cr>", desc = "Location List (Trouble)" },
            { "<leader>xq", "<cmd>Trouble qflist open<cr>", desc = "Quickfix List (Trouble)" },
            {
                "<leader>qp",
                function()
                    if require("trouble").is_open() then
                        ---@diagnostic disable-next-line: missing-fields, missing-parameter
                        require("trouble").prev({ jump = true })
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
                        ---@diagnostic disable-next-line: missing-fields, missing-parameter
                        require("trouble").next({ jump = true })
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
                ---@diagnostic disable-next-line:  missing-parameter
                require("nvim-surround").visual_surround()
            end, {})
        end,
        config = function(_, opts)
            require("nvim-surround").setup(opts)
            vim.api.nvim_set_hl(0, "NvimSurroundHighlight", { link = "CurSearch" })
        end,
    },
    { "nvim-treesitter/nvim-treesitter", lazy = false, build = ":TSUpdate", branch = "main" },
    require("omega.modules.editor.formatter"),
    require("omega.modules.editor.care"),
    require("omega.modules.editor.blink"),
    require("omega.modules.editor.snippets"),
    require("omega.modules.editor.which_key"),
    require("omega.modules.editor.autopairs"),
}
