local configs = {}
configs["neogen"] = function()
    require("neogen").setup({
        snippet_engine = "luasnip",
        enabled = true,
    })
end
return configs
