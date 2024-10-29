return {
    "max397574/care.nvim",
    enabled = require("omega.config").modules.completion == "care",
    lazy = false,
    -- event = "InsertEnter",
    dependencies = {
        "max397574/care-cmp",
        "max397574/cmp-greek",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-emoji",
        "saadparwaiz1/cmp_luasnip",
        -- "hrsh7th/cmp-path",
    },
    config = function()
        local labels = { "q", "w", "r", "t", "z", "i" }

        require("care.sources.path").setup()

        local demo = false
        if demo then
            vim.cmd([[hi clear @care.menu]])
            vim.cmd([[hi link @care.border @comment]])
            require("care").setup({
                ui = {
                    menu = {
                        border = "none",

                        format_entry = require("care.presets").Atom,
                        -- format_entry = function(entry, data)
                        --     local components = require("care.presets.components")
                        --     return {
                        --         components.Padding(1),
                        --         components.Label(entry, data, false),
                        --         components.Padding(1),
                        --         components.KindName(entry, false, "@comment"),
                        --         components.Padding(1),
                        --         components.ColoredBlock(entry, " "),
                        --         -- components.Padding(1),
                        --     }
                        -- end,
                    },
                },
            })
        else
            local border
            local border_config = require("omega.config").ui.completion.border
            if border_config == "half" then
                border = {
                    -- { "▄", "@care.border" },
                    -- { "▄", "@care.border" },
                    -- { "▄", "@care.border" },
                    -- { "█", "@care.border" },
                    -- { "▀", "@care.border" },
                    -- { "▀", "@care.border" },
                    -- { "▀", "@care.border" },
                    -- { "█", "@care.border" },
                    { "▗", "@care.border" },
                    { "▄", "@care.border" },
                    { "▖", "@care.border" },
                    { "▌", "@care.border" },
                    { "▘", "@care.border" },
                    { "▀", "@care.border" },
                    { "▝", "@care.border" },
                    { "▐", "@care.border" },
                }
            elseif border_config == "rounded" then
                border = {
                    { "╭", "@care.border" },
                    { "─", "@care.border" },
                    { "╮", "@care.border" },
                    { "│", "@care.border" },
                    { "╯", "@care.border" },
                    { "─", "@care.border" },
                    { "╰", "@care.border" },
                    { "│", "@care.border" },
                }
            elseif border_config == "none" then
                border = ""
            elseif border_config == "up_to_edge" then
                border = {
                    -- { "🭽", "@care.border" },
                    -- { "▔", "@care.border" },
                    -- { "🭾", "@care.border" },
                    -- { "▕", "@care.border" },
                    -- { "🭿", "@care.border" },
                    -- { "▁", "@care.border" },
                    -- { "🭼", "@care.border" },
                    -- { "▏", "@care.border" },
                    { "🬕", "@care.border" },
                    { "🬂", "@care.border" },
                    { "🬨", "@care.border" },
                    { "▐", "@care.border" },
                    { "🬷", "@care.border" },
                    { "🬭", "@care.border" },
                    { "🬲", "@care.border" },
                    { "▌", "@care.border" },
                }
            end
            -- border = "none"
            require("care").setup({
                ui = {
                    menu = {
                        border = border,
                        max_height = 30,

                        format_entry = function(entry, data)
                            -- return require("care.presets").Default(entry, data)
                            local labels = { "q", "w", "r", "t", "z", "i" }
                            local components = require("care.presets.components")
                            local preset_utils = require("care.presets.utils")
                            return {
                                components.ShortcutLabel(labels, entry, data),
                                components.Label(entry, data, true),
                                components.KindIcon(entry, "blended"),
                                {
                                    {
                                        " (" .. data.source_name .. ") ",
                                        preset_utils.kind_highlight(entry, "fg"),
                                    },
                                },
                            }
                        end,
                        alignments = { "left", "left", "left", "center" },
                        scrollbar = {
                            enabled = true,
                            -- character = "║",
                            character = (function()
                                if border_config == "up_to_edge" then
                                    return "▐"
                                else
                                    return "┃"
                                end
                            end)(),
                        },
                    },
                    ghost_text = {
                        -- enabled = false
                        -- position = "inline",
                    },
                    docs_view = {
                        max_height = 7,
                        -- border = "none",
                        scrollbar = { enabled = true },
                    },
                },
                sources = {
                    lsp = {
                        filter = function(entry)
                            return entry.completion_item.kind ~= 1
                        end,
                        -- max_entries = 3,
                        -- priority = 5,
                        -- enabled = false,
                    },
                    cmp_luasnip = {
                        -- max_entries = 2,
                    },
                    cmp_buffer = {
                        -- priority = 5,
                        enabled = false,
                    },
                    cmp_path = {
                        enabled = false,
                    },
                    cmp_calc = {
                        enabled = false,
                    },
                    path = {
                        priority = 1000,
                    },
                },
                -- completion_events = {},
                preselect = false,
                selection_behavior = "insert",
                sorting_direction = "away-from-cursor",
                snippet_expansion = function(body)
                    require("luasnip").lsp_expand(body)
                end,
                -- max_view_entries = 10,

                debug = true,
            })
        end

        -- Keymappings
        for i, label in ipairs(labels) do
            vim.keymap.set("i", "<c-" .. label .. ">", function()
                require("care").api.select_visible(i)
                require("care").api.confirm()
            end)
        end

        vim.keymap.set("i", "<c-n>", function()
            require("luasnip").jump(1)
        end)
        vim.keymap.set("i", "<c-p>", function()
            require("luasnip").jump(-1)
        end)

        vim.keymap.set("i", "<c-space>", function()
            if require("care").api.is_open() then
                local documentation = require("care").api.get_documentation()
                if #documentation == 0 then
                    return
                end
                local old_win = vim.api.nvim_get_current_win()
                vim.cmd.wincmd("s")
                local buf = vim.api.nvim_create_buf(false, true)
                vim.bo[buf].ft = "markdown"
                vim.api.nvim_buf_set_lines(buf, 0, -1, false, documentation)
                vim.api.nvim_win_set_buf(0, buf)
                vim.api.nvim_set_current_win(old_win)
            else
                require("care").api.complete()
            end
        end)

        vim.keymap.set("i", "<c-x><c-f>", function()
            require("care").api.complete(function(name)
                return name == "cmp_path"
            end)
        end)

        vim.keymap.set({ "i", "s" }, "<c-f>", function()
            if require("care").api.doc_is_open() then
                require("care").api.scroll_docs(4)
            elseif require("luasnip").choice_active() then
                require("luasnip").change_choice(1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
            end
        end)

        vim.keymap.set({ "i" }, "<ScrollWheelDown>", function()
            if require("care").api.is_open() then
                require("care").api.select_next(1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<ScrollWheelDown>"), "n", false)
            end
        end)

        vim.keymap.set({ "i" }, "<ScrollWheelUp>", function()
            if require("care").api.is_open() then
                require("care").api.select_prev(1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<ScrollWheelUp>"), "n", false)
            end
        end)

        vim.keymap.set({ "i", "s" }, "<c-d>", function()
            if require("care").api.doc_is_open() then
                require("care").api.scroll_docs(-4)
            elseif require("luasnip").choice_active() then
                require("luasnip").change_choice(-1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
            end
        end)

        vim.keymap.set("i", "<cr>", "<Plug>(CareConfirm)")
        vim.keymap.set("i", "<c-e>", "<Plug>(CareClose)")
        vim.keymap.set("i", "<c-j>", "<Plug>(CareSelectNext)")
        vim.keymap.set("i", "<c-k>", "<Plug>(CareSelectPrev)")
    end,
}
