local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta

local function reuse(idx)
    return f(function(args)
        return args[1][1]
    end, { idx })
end

ls.add_snippets("lua", {
    s(
        "M",
        fmta(
            [[local <> = {}
<>
return <>]],
            { i(1, "M"), i(2), reuse(1) }
        )
    ),
})
