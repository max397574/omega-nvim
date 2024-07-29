return {
    "max397574/care.nvim",
    enabled = require("omega.config").modules.completion == "care",
    lazy = false,
    dependencies = {
        "max397574/care-lsp",
        { "max397574/care-cmp" },
        "max397574/cmp-greek",
        "hrsh7th/cmp-calc",
        "hrsh7th/cmp-emoji",
        "hrsh7th/cmp-path",
        -- "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local labels = { "q", "w", "r", "t", "z", "i", "o" }

        require("care.config").setup({
            ui = {
                menu = {
                    max_height = 10,

                    format_entry = function(entry, data)
                        local deprecated = entry.completion_item.deprecated
                            or vim.tbl_contains(entry.completion_item.tags or {}, 1)
                        local completion_item = entry.completion_item
                        local type_icons = require("care.config").options.ui.type_icons
                        local entry_kind = type(completion_item.kind) == "string" and completion_item.kind
                            or require("care.utils.lsp").get_kind_name(completion_item.kind)
                        return {
                            {
                                {
                                    " " .. require("care.presets.utils").LabelEntries(labels)(entry, data) .. " ",
                                    "Comment",
                                },
                            },
                            { { completion_item.label .. " ", deprecated and "Comment" or "@care.entry" } },
                            {
                                {
                                    " " .. (type_icons[entry_kind] or type_icons.Text) .. " ",
                                    ("@care.type.%s"):format(entry_kind),
                                },
                            },
                        }
                    end,
                },
            },
        })

        -- Keymappings
        for i, label in ipairs(labels) do
            vim.keymap.set("i", "<c-" .. label .. ">", function()
                require("care").api.select_visible(i)
            end)
        end

        vim.keymap.set("i", "<c-n>", function()
            vim.snippet.jump(1)
        end)
        vim.keymap.set("i", "<c-p>", function()
            vim.snippet.jump(-1)
        end)
        vim.keymap.set("i", "<c-space>", function()
            require("care").api.complete()
        end)

        vim.keymap.set("i", "<c-f>", function()
            if require("care").api.doc_is_open() then
                require("care").api.scroll_docs(4)
            elseif require("luasnip").choice_active() then
                require("luasnip").change_choice(1)
            else
                vim.api.nvim_feedkeys(vim.keycode("<c-f>"), "n", false)
            end
        end)

        vim.keymap.set("i", "<c-d>", function()
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
