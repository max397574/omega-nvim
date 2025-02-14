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

local rec_tbl_cell
rec_tbl_cell = function()
    return sn(nil, {
        c(1, {
            t({ "" }),
            sn(nil, {
                c(1, { sn(nil, { t("["), i(1), t("],") }), sn(nil, { t("[$"), i(1), t("$],") }) }),
                d(2, rec_tbl_cell, {}),
            }),
        }),
    })
end

local function math_auto_snip(trigger)
    return {
        trig = trigger,
        wordTrig = false,
        snippetType = "autosnippet",
    }
end

ls.add_snippets("typst", {
    s(math_auto_snip("Rr"), fmt("RR", {})),
})

ls.add_snippets("typst", {
    s("para", fmt("#paragraph[{}]", { i(1) })),
    s("def", fmt('#definition("{}")[{}]', { i(1), i(0) })),
    s("env", fmt('#environment("{}")[{}]', { i(1), i(0) })),
    s("lemma", fmt('#lemma("{}")[{}]', { i(1), i(0) })),
    s("theorem", fmt('#theorem("{}")[{}]', { i(1), i(0) })),
    s(
        "fntable",
        fmt(
            [[#table(
  fill: none,
  stroke: none,
  columns: {},
  table.hline(y: 1),
  table.vline(x: 1),
  {}
)]],
            { i(1), d(2, rec_tbl_cell, {}) }
        )
    ),
    s(
        "pseudocode",
        fmt(
            [[#block(breakable: false)[
  #pseudocode-list(
    title: smallcaps[test],
    booktabs: true,
  )[
    - _DoFanceStuff_$(A[1..n], b)$
    - #line(length: 4cm, stroke: 2pt)
    + code #h(1fr) $triangle$ _comment_
    + *while* $l<= r$ *do*
      + idk
    + *return* "nicht gefunden"
  ]
]
]],
            {}
        )
    ),

    s("red", fmt("#text(red)[{}]", { i(1) })),
    s(math_snip("N"), fmt("bdu(N)({})", { i(1) })),
    s(math_snip("R"), fmt("bdu(R)({})", { i(1) })),
    s(math_snip("C"), fmt("bdu(C)({})", { i(1) })),
    s(math_snip("LN"), fmt("bdu(L N)({})", { i(1) })),
    s(math_snip("an"), fmt("({}_n)_(n>=1)", { i(1, "a") })),
})
