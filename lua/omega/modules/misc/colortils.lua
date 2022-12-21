local colortils_mod = {}

colortils_mod.configs = {
    ["colortils.nvim"] = function()
        require("colortils").setup({
            border = require("omega.utils").border(),
            background = "#1e222a",
        })
    end,
}

return colortils_mod
