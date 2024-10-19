local autopairs = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = { map_cr = false, map_bs = false },
}

autopairs.config = function(_, opts)
    local Rule = require("nvim-autopairs.rule")
    local npairs = require("nvim-autopairs")
    require("nvim-autopairs").setup(opts)
    require("nvim-autopairs").clear_rules()
    npairs.add_rule(Rule("$", "$", "typst"):with_move(function()
        return true
    end))
    npairs.add_rule(Rule("`", "`", "typst"):with_move(function()
        return true
    end))
end

return autopairs
