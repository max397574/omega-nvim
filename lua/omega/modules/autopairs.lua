local autopairs = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
}

autopairs.config = function()
    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")
    require("nvim-autopairs").setup({
        ignored_next_char = "",
        -- map_c_w = true,
        -- disable_filetype = { "norg" },
    })
    npairs.add_rule(Rule("$", "$", "tex"))
    npairs.remove_rule("[")
    npairs.add_rule(Rule("[", "]", "-norg"))
end

return autopairs
