local config = require("omega.config").values

local cmp = {
    dir = "~/neovim_plugins/nvim-cmp",
    event = "InsertEnter",
}

cmp.dependencies = {
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
}

cmp.config = function()
    local noice_config = {
        cmdline = {
            enabled = true,
            format = {
                search_down = {
                    kind = "Search",
                    pattern = "^/",
                    lang = "regex",
                    view = "cmdline",
                },
                inspect = {
                    conceal = true,
                    icon = " ",
                    lang = "lua",
                    pattern = "^:%s*lua =%s*",
                },
            },
            view = "cmdline",
        },
        popupmenu = {
            enabled = true,
            ---@type 'nui'|'cmp'
            backend = "nui",
        },
        notiy = {
            enabled = true,
        },
        messages = {
            enabled = true,
        },
        lsp = {
            hover = {
                enabled = true,
            },
            progress = {
                enabled = false,
            },
            signature = {
                enabled = true,
            },
            message = {
                enabled = true,
            },
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        routes = {
            {
                view = "notify",
                filter = { event = "msg_showmode" },
            },
            {
                view = "notify",
                filter = { find = "overly long" },
                opts = { skip = true },
            },
            {
                filter = {
                    event = "msg_show",
                    kind = "",
                    find = "written",
                },
                opts = { skip = true },
            },
        },
    }
    if vim.tbl_contains({ "bottom", "top" }, config.noice_cmdline_position) then
        noice_config.cmdline.view = nil
        noice_config.views = {
            cmdline_popup = {
                position = {
                    row = vim.o.lines - 3,
                    col = "50%",
                },
                size = {
                    width = math.floor(vim.o.columns * 0.9),
                    height = "auto",
                },
                win_options = {
                    conceallevel = 0,
                },
            },
            popupmenu = {
                position = {
                    row = vim.o.lines - 16,
                    col = "50%",
                },
                size = {
                    width = math.floor(vim.o.columns * 0.9),
                    height = 10,
                },
                border = {
                    style = "rounded",
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                },
            },
        }
        if config.noice_cmdline_position == "top" then
            noice_config.views.cmdline_popup.position.row = 2
            noice_config.views.popupmenu.position.row = 4
        end
    end
    require("plenary.reload").reload_module("noice")
    require("noice").setup(noice_config)

    local cmp = require("cmp")
    local types = require("cmp.types")
    local luasnip = require("luasnip")
    local neogen = require("neogen")
    local str = require("cmp.utils.str")
    local kind = require("omega.modules.langs.kind")

    local function get_abbr(vim_item, entry)
        local word = entry:get_insert_text()
        if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
            word = vim.lsp.util.parse_snippet(word)
        end
        word = str.oneline(word)

        -- concatenates the string
        local max = 50
        if string.len(word) >= max then
            local before = string.sub(word, 1, math.floor((max - 3) / 2))
            word = before .. "..."
        end

        -- if
        --     entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
        --     and string.sub(vim_item.abbr, -1, -1) == "~"
        -- then
        -- word = word .. "~"
        -- end
        return word
    end
    require("lazy").load({ plugins = { "LuaSnip" } })
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

    local function t(string)
        return vim.api.nvim_replace_termcodes(string, true, true, true)
    end
    local border = {
        { "╭", "CmpBorder" },
        { "─", "CmpBorder" },
        { "╮", "CmpBorder" },
        { "│", "CmpBorder" },
        { "╯", "CmpBorder" },
        { "─", "CmpBorder" },
        { "╰", "CmpBorder" },
        { "│", "CmpBorder" },
    }

    local cmp_config = {
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = {
            ["<C-f>"] = cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                    cmp.scroll_docs(4)
                elseif luasnip.choice_active() then
                    require("luasnip").change_choice(1)
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),
            ["<C-d>"] = cmp.mapping(function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                    cmp.scroll_docs(-4)
                elseif luasnip.choice_active() then
                    require("luasnip").change_choice(-1)
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),

            ["<c-j>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({
                        behavior = cmp.SelectBehavior.Insert,
                    })
                elseif luasnip.jumpable(1) then
                    luasnip.jump(1)
                elseif neogen.jumpable(1) then
                    neogen.jump_next()
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),

            ["<c-k>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({
                        behavior = cmp.SelectBehavior.Insert,
                    })
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                elseif neogen.jumpable(-1) then
                    vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_prev()<CR>"), "")
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),

            ["<c-space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),

            ["<C-e>"] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),

            ["<CR>"] = cmp.mapping({
                i = cmp.mapping.confirm({
                    select = true,
                    behavior = cmp.ConfirmBehavior.Insert,
                }),
                c = cmp.mapping.confirm({
                    select = false,
                    behavior = cmp.ConfirmBehavior.Insert,
                }),
            }),
            ["<C-l>"] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                    require("luasnip").change_choice(1)
                elseif neogen.jumpable() then
                    vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_next()<CR>"), "")
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),
            ["<C-h>"] = cmp.mapping(function(fallback)
                if luasnip.choice_active() then
                    require("luasnip").change_choice(-1)
                elseif neogen.jumpable(-1) then
                    vim.fn.feedkeys(t("<cmd>lua require('neogen').jump_prev()<CR>"), "")
                else
                    fallback()
                end
            end, {
                "i",
                "s",
            }),
        },

        sources = {
            -- { name = "buffer", priority = 7, keyword_length = 4 },
            { name = "path", priority = 5 },
            { name = "emoji", priority = 3 },
            { name = "greek", priority = 1 },
            { name = "calc", priority = 4 },

            -- { name = "cmdline", priority = 4 },
            -- { name = "copilot", priority = 8 },
            -- { name = "cmp_tabnine", priority = 8 },

            { name = "nvim_lsp", priority = 9 },
            { name = "luasnip", priority = 8 },
            -- { name = "neorg", priority = 6 },
            { name = "latex_symbols", priority = 1 },
            { name = "nvim_lsp_signature_help", priority = 10 },
        },
        enabled = function()
            if vim.bo.ft == "TelescopePrompt" then
                return false
            end
            if luasnip.choice_active() then
                return false
            end
            if vim.bo.ft == "lua" then
                return true
            end
            -- if require("cmp_dap").is_dap_buffer() then
            --     return true
            -- end
            local lnum, col = vim.fn.line("."), math.min(vim.fn.col("."), #vim.fn.getline("."))
            for _, syn_id in ipairs(vim.fn.synstack(lnum, col)) do
                syn_id = vim.fn.synIDtrans(syn_id) -- Resolve :highlight links
                if vim.fn.synIDattr(syn_id, "name") == "Comment" then
                    return false
                end
            end
            if string.find(vim.api.nvim_buf_get_name(0), "neorg://") then
                return false
            end
            if string.find(vim.api.nvim_buf_get_name(0), "s_popup:/") then
                return false
            end
            return true
        end,
        sorting = {
            comparators = cmp.config.compare.recently_used,
        },
        experimental = {
            ghost_text = true,
        },
    }
    if config.cmp_theme == "border" then
        cmp_config.window = {
            completion = {
                border = border,
                scrollbar = "║",
            },
            documentation = {
                border = border,
                scrollbar = "║",
            },
        }
        cmp_config.formatting = {
            fields = {
                "kind",
                "abbr",
                "menu",
            },
            format = kind.cmp_format({
                with_text = false,
                before = function(entry, vim_item)
                    vim_item.abbr = get_abbr(vim_item, entry)

                    vim_item.dup = ({
                        buffer = 1,
                        path = 1,
                        nvim_lsp = 0,
                    })[entry.source.name] or 0

                    return vim_item
                end,
            }),
        }
    elseif config.cmp_theme == "no-border" then
        cmp_config.window = {
            completion = {
                border = {
                    { "▄", "CmpBorder" },
                    { "▄", "CmpBorder" },
                    { "▄", "CmpBorder" },
                    { "█", "CmpBorder" },
                    { "▀", "CmpBorder" },
                    { "▀", "CmpBorder" },
                    { "▀", "CmpBorder" },
                    { "█", "CmpBorder" },
                },
                winhighlight = "Normal:Pmenu,FloatBorder:CmpDocumentationBorder,Search:None",
                left_side_padding = 0,
                right_side_padding = 1,
                col_offset = 1,
            },
            documentation = {
                border = "rounded",
                winhighlight = "FloatBorder:CmpDocumentationBorder,Search:None",
                max_width = 80,
                col_offset = -1,
                max_height = 12,
            },
        }
        cmp_config.formatting = {
            fields = {
                "kind",
                "padding",
                "abbr",
                "padding",
                "menu",
            },
            format = function(entry, item)
                item.menu = item.kind
                item.menu_hl_group = ("CmpItemKindMenu%s"):format(item.kind)
                item.padding = " "
                item.kind = kind.presets.default[item.kind] or ""
                item.dup = ({
                    buffer = 1,
                    path = 1,
                    nvim_lsp = 0,
                })[entry.source.name] or 0
                if item.abbr == "" then
                    item.dup = 1
                end

                item.abbr = get_abbr(item, entry)

                return item
            end,
        }
    end
    require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
        sources = {
            { name = "dap" },
        },
    })
    cmp.setup(cmp_config)

    -- cmp.setup.cmdline(":", {
    --     sources = {
    --         { name = "cmdline", group_index = 1, max_item_count = 5 },
    --         -- { name = "cmdline" },
    --         { name = "cmdline_history", group_index = 2, max_item_count = 5 },
    --     },
    --     formatting = {
    --         fields = { "abbr" },
    --         format = function(entry, item)
    --             item.abbr = get_abbr(item, entry)
    --             item.abbr_hl_group = "Function"
    --             return item
    --         end,
    --     },
    -- })
    --
    -- cmp.setup.cmdline("/", {
    --     sources = {
    --         { name = "cmdline_history" },
    --         { name = "buffer" },
    --     },
    --     formatting = {
    --         fields = { "abbr" },
    --         format = function(entry, item)
    --             item.abbr = get_abbr(item, entry)
    --             item.abbr_hl_group = "Function"
    --             return item
    --         end,
    --     },
    -- })

    vim.api.nvim_set_hl(0, "NormalFloat", {})
    if not neorg then
        return
    end
    local ok = pcall(neorg.modules.load_module, "core.norg.completion", nil, {
        engine = "nvim-cmp",
    })
    if ok then
        table.insert(cmp_config.sources, { name = "neorg", priority = 6 })
        cmp.setup(cmp_config)
    end
end

return cmp
