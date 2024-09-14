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
        print(node:type())
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
    s(math_snip("vec"), {
        c(1, {
            sn(1, { t("vec("), i(1), t(", "), i(2), t(")"), i(0) }),
            sn(2, {
                t("vec("),
                i(1),
                t(", "),
                i(2),
                t(", "),
                i(3),
                t(")"),
                i(0),
            }),
            sn(3, { t("vec("), i(1, "v"), t("_1, "), reuse(1), t("_2)"), i(0) }),
            sn(4, {
                t("vec("),
                i(1, "v"),
                t("_1, "),
                reuse(1),
                t("_2, "),
                reuse(1),
                t("_3)"),
                i(0),
            }),
            sn(5, {
                t("vec("),
                i(1, "v"),
                t("_1, "),
                reuse(1),
                t("_2, dots.v, "),
                reuse(1),
                t("_"),
                i(2, "n"),
                t(")"),
                i(0),
            }),
        }),
    }),
    s(math_snip("seq"), {
        i(1, "a"),
        t("_1, "),
        reuse(1),
        t("_2, "),
        t("..., "),
        reuse(1),
        t("_n"),
        i(0),
    }),
    s(math_snip("sum"), {
        c(1, { t("limits(sum)"), t("sum") }),
        t("_"),
        c(2, {
            sn(1, { i(1, "j") }),
            sn(2, { t("("), i(1, "j"), t("="), i(2, "1"), t(")") }),
        }),
        t("^"),
        c(3, {
            sn(1, { i(1, "n") }),
            sn(2, { t("("), i(1, "n"), t(")") }),
        }),
        i(0),
    }),
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
    s(math_snip("genmatrix"), {
        t({
            "mat(a_(1,1), a_(1,2), ..., a_(1,n);a_(2,1), a_(2,2), ..., a_(2,n);dots.v, dots.v, dots.down, dots.v;a_(m,1), a_(m,2), ..., a_(m,n);)",
        }),
    }),
    s("sum", {}),
})
