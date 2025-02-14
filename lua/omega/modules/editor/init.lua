return {
    {
        "max397574/better-escape.nvim",
        -- "Sam-programs/better-escape.nvim",
        -- branch = "multiple_keys",
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
            { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        },
        specs = {
            {
                "folke/snacks.nvim",
                opts = {
                    picker = {
                        win = {
                            input = {
                                keys = {
                                    ["ß"] = { "flash", mode = { "n", "i" } },
                                    ["s"] = { "flash" },
                                },
                            },
                        },
                        actions = {
                            flash = function(picker)
                                require("flash").jump({
                                    pattern = "^",
                                    label = { after = { 0, 0 } },
                                    search = {
                                        mode = "search",
                                        exclude = {
                                            function(win)
                                                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype
                                                    ~= "snacks_picker_list"
                                            end,
                                        },
                                    },
                                    action = function(match)
                                        local idx = picker.list:row2idx(match.pos[1])
                                        picker.list:_move(idx, true, true)
                                    end,
                                })
                            end,
                        },
                    },
                },
            },
        },
    },
    {
        "folke/trouble.nvim",
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
    { "MagicDuck/grug-far.nvim", opts = {}, cmd = { "GrugFar" } },
    require("omega.modules.editor.ki"),
    require("omega.modules.editor.formatter"),
    require("omega.modules.editor.cmp"),
    require("omega.modules.editor.care"),
    require("omega.modules.editor.blink"),
    require("omega.modules.editor.snippets"),
    require("omega.modules.editor.telescope"),
    require("omega.modules.editor.treesitter"),
    require("omega.modules.editor.which_key"),
    require("omega.modules.editor.terminal"),
    require("omega.modules.editor.autopairs"),
}
