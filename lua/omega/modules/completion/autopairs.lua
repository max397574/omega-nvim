local autopairs = {}

autopairs.configs = {
    ["nvim-autopairs"] = function()
        local Rule = require("nvim-autopairs.rule")
        local npairs = require("nvim-autopairs")
        require("nvim-autopairs").setup({
            ignored_next_char = "",
            -- map_c_w = true,
            -- disable_filetype = { "norg" },
        })
        npairs.add_rule(Rule("$", "$", "tex"))
    end,
}

return autopairs
