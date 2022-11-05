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
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local postfix = require("luasnip.extras.postfix").postfix

local parse = ls.parser.parse_snippet
local time = [[
local start = os.clock()
print(os.clock()-start.."s")
]]

local module_snippet = [[
local ${1:M} = {}
${0}
return $1]]

local loc_func = [[
local function ${1:name}(${2})
    ${0}
end
]]

local inspect_snippet = [[
print("${1:variable}:")
vim.pretty_print($1)]]

local map_cmd = [[<cmd>${0}<CR>]]

local it
it = function()
    return sn(nil, {
        c(1, {
            t({ "" }),
            sn(nil, {
                t({ "", "" }),
                t('\tit("'),
                i(1),
                t('",function()'),
                t({ "", "" }),
                t("\t\t"),
                c(2, {
                    t("assert.equals"),
                    t("assert.same"),
                    t("assert.is_true"),
                    t("assert.is_nil"),
                    t("assert.is_table"),
                }),
                t("("),
                i(3),
                t(")"),
                t({ "", "" }),
                t("\tend)"),
                t({ "", "" }),
                d(4, it, {}),
            }),
        }),
    })
end

local describe = function()
    return sn(nil, {
        t('describe("'),
        i(1),
        t('",function()'),
        d(2, it, {}),
        t({ "", "" }),
        t("end)"),
    })
end

local function highlight_choice()
    return sn(nil, {
        t({ "" }),
        c(1, {
            t({ "" }),
            sn(nil, {
                c(1, {
                    sn(nil, { t({ "fg=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "bg=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "sp=" }), i(1), t({ "," }) }),
                    sn(nil, { t({ "italic=true," }), i(1) }),
                    sn(nil, { t({ "bold=true," }), i(1) }),
                    sn(nil, { t({ "underline=true," }), i(1) }),
                    sn(nil, { t({ "undercurl=true," }), i(1) }),
                }),
                d(2, highlight_choice, {}),
            }),
        }),
    })
end

vim.api.nvim_set_hl(0, "lasjdf", { sp = "#FF0000", bold = true })

ls.add_snippets("lua", {
    s("high", {
        t({ 'vim.api.nvim_set_hl(0,"' }),
        i(1, "group-name"),
        t({ '",{' }),
        d(2, highlight_choice, {}),
        t({ "})" }),
        i(0),
    }),
    parse({ trig = "time" }, time),
    parse({ trig = "M" }, module_snippet),
    parse({ trig = "lf" }, loc_func),
    parse({ trig = "cmd" }, map_cmd),
    parse({ trig = "inspect" }, inspect_snippet),
    s("lreq", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })), -- to lreq, bind parse the list
    s("test_desc", {
        c(1, {
            d(1, describe, {}),
            sn(nil, {
                t({ "---@diagnostic disable: undefined-global", "" }),
                d(1, describe, {}),
            }),
        }),
    }),
    s("for", {
        t("for "),
        c(1, {
            sn(nil, {
                i(1, "k"),
                t(", "),
                i(2, "v"),
                t(" in "),
                c(3, { t("pairs"), t("ipairs") }),
                t("("),
                i(4),
                t(")"),
            }),
            sn(nil, { i(1, "i"), t(" = "), i(2), t(", "), i(3) }),
        }),
        t({ " do", "\t" }),
        i(0),
        t({ "", "end" }),
    }),
    s("inc", {
        i(1, "thing"),
        t(" = "),
        f(function(args)
            return args[1][1]
        end, 1),
        t(" + "),
        i(2, "1"),
        i(0),
    }),
    s("dec", {
        i(1, "thing"),
        t(" = "),
        f(function(args)
            return args[1][1]
        end, 1),
        t(" - "),
        i(2, "1"),
        i(0),
    }),
    s("ps", {
        t("print("),
        i(1, "<text>"),
        t(")"),
    }),
    s("buf", {
        t("local buf = vim.api.nvim_create_buf(false,true)"),
    }),
    s("win", {
        c(1, {
            t({
                "local width = vim.api.nvim_win_get_width(0)",
                "local height = vim.api.nvim_win_get_height(0)",
                "",
            }),
            t(""),
        }),
        c(2, { t("local winnr ="), t("") }),
        t("vim.api.nvim_open_win("),
        i(3, "buf"),
        t(", "),
        c(4, { t("false"), t("true") }),
        t({ ", {", "" }),
        t("    relative = "),
        c(5, {
            t('"editor"'),
            t('"win"'),
            t('"cursor"'),
        }),
        t({ ",", "" }),
        t("    width = "),
        i(6),
        t({ ",", "" }),
        t("    height = "),
        i(7),
        t({ ",", "" }),
        t("    style = "),
        i(8, '"minimal"'),
        t({ ",", "" }),
        t("    border = "),
        i(9, '"rounded"'),
        t({ ",", "" }),
        t("    row = "),
        i(10),
        t({ ",", "" }),
        t("    col = "),
        i(11),
        t({ ",", "" }),
        t("})"),
    }),
    s("fn", {
        c(1, {
            sn(nil, {
                t("local function "),
                i(1),
                t("("),
                i(2),
                t({ ")", "    " }),
                i(3),
                t({ "", "end", "" }),
                i(0),
            }),
            sn(nil, {
                t("function("),
                i(1),
                t(")"),
                i(2),
                t(" end"),
                i(0),
            }),
            sn(nil, {
                t("function "),
                d(1, function()
                    local line_count = vim.api.nvim_buf_line_count(0)
                    local line = vim.api.nvim_buf_get_lines(0, line_count - 1, line_count, false)[1]
                    local module = line:match("return ([%w_]+)")
                    return sn(nil, {
                        i(1, module or ""),
                    })
                end),
                t("."),
                i(2),
                t("("),
                i(3),
                t({ ")", "    " }),
                i(4),
                t({ "", "end", "" }),
                i(0),
            }),
        }),
    }),
})
