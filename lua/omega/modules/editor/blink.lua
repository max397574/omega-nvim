local blink = {
    -- "max397574/blink.cmp",
    "saghen/blink.cmp",
    version = "1.*",
    lazy = false,
}

local labels = { "q", "w", "r", "t", "z", "i" }
local keymaps = {
    preset = "none",
    ["<c-j>"] = {
        function(cmp)
            cmp.select_next()
        end,
    },
    ["<c-k>"] = {
        function(cmp)
            cmp.select_prev()
        end,
    },
    ["<c-space>"] = {
        function(cmp)
            cmp.show()
        end,
    },
    ["<CR>"] = {
        function(cmp)
            return cmp.select_and_accept()
        end,
        "fallback",
    },
    ["<c-f>"] = {
        function(cmp)
            return cmp.scroll_documentation_down(4)
        end,
        function()
            if require("luasnip").choice_active() then
                require("luasnip").change_choice(1)
            else
                return "<c-f>"
            end
        end,
    },
    ["<c-d>"] = {
        function(cmp)
            return cmp.scroll_documentation_up(4)
        end,
        function()
            if require("luasnip").choice_active() then
                require("luasnip").change_choice(-1)
            else
                return "<c-d>"
            end
        end,
    },
}

for i, label in ipairs(labels) do
    ---@diagnostic disable-next-line: assign-type-mismatch
    keymaps["<c-" .. label .. ">"] = {
        function(cmp)
            cmp.accept({ index = i })
        end,
    }
end

---@param ctx blink.cmp.DrawItemContext
local function get_color(ctx)
    if ctx.item.kind ~= 16 then
        return nil
    end
    local doc = ctx.item.documentation and (ctx.item.documentation.value or ctx.item.documentation or nil) or nil
    if doc and doc:find("#%x%x%x%x%x%x") then
        local start, finish = doc:find("#%x%x%x%x%x%x")
        if start and finish then
            return doc:sub(start, finish)
        end
    end
end

local function get_highlight_for_hex(hex)
    -- Adapted from nvchad
    local hl = "hex-" .. hex:sub(2)
    if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then
        vim.api.nvim_set_hl(0, hl, { fg = hex })
    end
    return hl
end

local bc = "@cmp.border"
local border = {
    { "🬕", bc },
    { "🬂", bc },
    { "🬨", bc },
    { "▐", bc },
    { "🬷", bc },
    { "🬭", bc },
    { "🬲", bc },
    { "▌", bc },
}

---@module 'blink.cmp'
---@type blink.cmp.Config
blink.opts = {
    keymap = keymaps,
    snippets = { preset = "luasnip" },
    completion = {
        documentation = { auto_show = true },
        ghost_text = { enabled = true },
        list = {
            selection = {
                auto_insert = false,
            },
        },
        menu = {
            draw = {
                align_to = "none",
                columns = {
                    { "item_idx" },
                    { "label", "color_block", gap = 1 },
                    { "kind_icon_blended" },
                    { "space", "source_name", "space" },
                },
                components = {
                    item_idx = {
                        text = function(ctx)
                            return ctx.idx > #labels and " " or labels[ctx.idx]
                        end,
                        highlight = "Special",
                    },
                    label = {
                        text = function(ctx)
                            return ctx.item.label
                        end,
                        highlight = function(ctx)
                            return ctx.deprecated and "@cmp.deprecated" or "@cmp.entry"
                        end,
                        width = {
                            fill = false,
                        },
                    },
                    space = {
                        text = function()
                            return ""
                        end,
                        highlight = function()
                            return "@cmp.menu"
                        end,
                        width = {
                            fill = true,
                        },
                    },
                    color_block = {
                        text = function(ctx)
                            local color = get_color(ctx)
                            if not color then
                                return nil
                            end
                            return " "
                        end,
                        highlight = function(ctx)
                            local color = get_color(ctx)
                            if not color then
                                return nil
                            end
                            return get_highlight_for_hex(color) or "@cmp.entry"
                        end,
                    },
                    kind_icon_blended = {
                        text = function(ctx)
                            return " " .. ctx.kind_icon .. " "
                        end,
                        highlight = function(ctx)
                            return ("@cmp.type.blended.%s"):format(ctx.kind)
                        end,
                    },
                    source_name = {
                        text = function(ctx)
                            return " (" .. ctx.source_name .. ") "
                        end,
                        highlight = function(ctx)
                            return ("@cmp.type.%s"):format(ctx.kind)
                        end,
                    },
                },
            },
            border = border,
        },
    },
    cmdline = { enabled = false },
    signature = { enabled = true },
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
            lsp = {
                fallbacks = { "buffer" },
                opts = { tailwind_color_icon = "󰏘 " },
            },
        },
    },
}

function blink.config(_, opts)
    local hl = function(...)
        vim.api.nvim_set_hl(0, ...)
    end

    require("blink.cmp").setup(opts)
    hl("BlinkCmpMenuSelection", { link = "Visual" })
end

return blink
