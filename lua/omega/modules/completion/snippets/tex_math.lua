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
local types = require("luasnip.util.types")
local util = require("luasnip.util.util")

local in_mathzone = require("omega.utils").in_mathzone

ls.add_snippets("tex", {
    s(
        { snippetType = "autosnippet", trig = "//" },
        d(1, function()
            if not in_mathzone() then
                return sn(nil, { t({ "//" }) })
            else
                return sn(nil, {
                    t({ "\\frac{" }),
                    i(1),
                    t({ "}{" }),
                    i(2),
                    t({ "}" }),
                })
            end
        end)
    ),
    s(
        { snippetType = "autosnippet", trig = "sr", wordTrig = false },
        f(function()
            if not in_mathzone() then
                return "sr"
            end
            return "^2"
        end)
    ),
    s(
        { snippetType = "autosnippet", trig = "cb", wordTrig = false },
        f(function()
            if not in_mathzone() then
                return "cb"
            end
            return "^3"
        end)
    ),
    s(
        { snippetType = "autosnippet", trig = "comp", wordTrig = false },
        f(function()
            if not in_mathzone() then
                return "comp"
            end
            return "^{c}"
        end)
    ),
    s({ snippetType = "autosnippet", trig = "(%d+)/", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\frac{" .. snip.captures[1] .. "}{"), i(1), t("}") }, i(0))
        end),
    }, {
        condition = function()
            return in_mathzone()
        end,
    }),
    s({ snippetType = "autosnippet", trig = "(%u%u)vec", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\overrightarrow{" .. snip.captures[1] .. "}") }, i(0))
        end),
    }, {
        condition = function()
            return in_mathzone()
        end,
    }),
    s({ snippetType = "autosnippet", trig = "(%a)vec", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\vec{" .. snip.captures[1] .. "}") }, i(0))
        end),
    }, {
        condition = function()
            return in_mathzone()
        end,
    }),
    s({ snippetType = "autosnippet", trig = "(%a)hat", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\hat{" .. snip.captures[1] .. "}") }, i(0))
        end),
    }, {
        condition = function(_, _, _)
            return in_mathzone()
        end,
    }),
    s({ snippetType = "autosnippet", trig = "hat" }, { t("\\hat{"), i(1), t("}"), i(0) }, {
        condition = function()
            return in_mathzone()
        end,
    }),
    s({ snippetType = "autosnippet", trig = "bar" }, { t("\\bar{"), i(1), t("}"), i(0) }, {
        condition = function()
            return in_mathzone()
        end,
    }),
}, {})
ls.add_snippets("tex", {
    s({ trig = "*", wordTrig = false }, { t("{\\cdot"), t("}"), i(0) }, {
        condition = function()
            return in_mathzone()
        end,
    }),
    s({ snippetType = "autosnippet", trig = "(%a)bar", regTrig = true }, {
        d(1, function(_, snip, _)
            return sn(nil, { t("\\bar{" .. snip.captures[1] .. "}") }, i(0))
        end),
    }, {
        condition = function(_, _, _)
            return in_mathzone()
        end,
    }),
    s(
        { trig = "ss", wordTrig = false },
        d(1, function()
            if not in_mathzone() then
                return sn(nil, { t({ "ss" }) })
            end
            return sn(nil, {
                t({ "^{" }),
                i(1),
                t({ "}" }),
                i(0),
            })
        end)
    ),
    s("bdm", {
        t([=[\boldmath{$]=]),
        i(1),
        t([[$}]]),
        i(0),
    }),
    s("RR", {
        t([=[\mathbb{]=]),
        i(i, "R"),
        t([=[}]=]),
        i(0),
    }, {
        condition = function()
            return in_mathzone()
        end,
    }),
    -- System of equations
    s("==", {
        t({ [=[\left[]=], "" }),
        t({ [[\begin{aligned}]], "" }),
        i(1),
        t({ [[&=]] }),
        i(2),
        t({ [[\\]], "" }),
        i(3),
        t({ [[&=]] }),
        i(4),
        t({ "", [[\end{aligned}]], "" }),
        t({ [=[\right]]=] }),
    }),
    s("<>", {
        t([[\Longleftrightarrow]]),
    }),
    s("->", {
        t([[\implies]]),
    }),
    s({ trig = "vec" }, {
        c(1, {
            sn(nil, {
                t("\\vec{"),
                i(1),
                t("}"),
                i(0),
            }),
            sn(nil, {
                t({ [[\begin{pmatrix}]], "" }),
                i(1, "a"),
                t({ [[_x\\]], "" }),
                f(function(arg)
                    return arg[1]
                end, 1),
                t({ [[_y]], "" }),
                t({ [[\end{pmatrix}]] }),
            }),
            sn(nil, {
                t({ [[\begin{pmatrix}]], "" }),
                i(1, "a"),
                t({ [[\\]], "" }),
                i(2, "a"),
                t({ "", "" }),
                t({ [[\end{pmatrix}]] }),
            }),
            sn(nil, {
                t({ [[\begin{pmatrix}]], "" }),
                i(1, "a"),
                t({ [[_x\\]], "" }),
                f(function(arg)
                    return arg[1]
                end, 1),
                t({ [[_y\\]], "" }),
                f(function(arg)
                    return arg[1]
                end, 1),
                t({ [[_z]], "" }),
                t({ [[\end{pmatrix}]] }),
            }),
            sn(nil, {
                t({ [[\begin{pmatrix}]], "" }),
                i(1, "a"),
                t({ [[\\]], "" }),
                i(2, "a"),
                t({ [[\\]], "" }),
                i(3, "a"),
                t({ "", "" }),
                t({ [[\end{pmatrix}]] }),
            }),
        }),
    }, {
        condition = function()
            return in_mathzone()
        end,
    }),
}, {})
