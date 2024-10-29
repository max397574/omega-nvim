---@diagnostic disable: unused-local
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet

local function in_math()
    local node = vim.treesitter.get_node()

    while node do
        if node:type() == "source_file" then
            return false
        elseif vim.tbl_contains({ "math" }, node:type()) then
            return true
        end
        node = node:parent()
    end
    return false
end

local function reuse(idx)
    return f(function(args)
        return args[1][1]
    end, { idx })
end

local function math_snip(trigger)
    return {
        trig = trigger,
        condition = function()
            return in_math()
        end,
        show_condition = function()
            return in_math()
        end,
    }
end

ls.add_snippets("typst", {
    -- can also use #truth-table()
    s("fntable", {
        c(1, {
            t({
                "#table(",
                "  columns: 3,",
                "  align: center,",
                "  [$A$], [$B$], [$$],",
                "  [0], [0], [0],",
                "  [0], [1], [0],",
                "  [1], [0], [0],",
                "  [1], [1], [0],",
                ")",
            }),
            t({
                "#table(",
                "  columns: 4,",
                "  align: center,",
                "  [$A$], [$B$], [$C$], [$$],",
                "  [0], [0], [0], [0],",
                "  [0], [0], [1], [0],",
                "  [0], [1], [0], [0],",
                "  [0], [1], [1], [0],",
                "  [1], [0], [0], [0],",
                "  [1], [0], [1], [0],",
                "  [1], [1], [0], [0],",
                "  [1], [1], [1], [0],",
                ")",
            }),
        }),
    }),
    s("red", fmt("#text(red)[{}]", { i(1) })),
    s(math_snip("N"), fmt("bdu(N)({})", { i(1) })),
    s(math_snip("R"), fmt("bdu(R)({})", { i(1) })),
    s(math_snip("C"), fmt("bdu(C)({})", { i(1) })),
    s(math_snip("LN"), fmt("bdu(L N)({})", { i(1) })),
})
