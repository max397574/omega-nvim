---@type OmegaModule
local neogen_mod = {}

neogen_mod.plugins = {
    ["neogen"] = {
    },
}

neogen_mod.keybindings = function()
    local wk = require("which-key")
    wk.register({
        a = {
            function()
                require("neogen").generate({ snippet_engine = "luasnip" })
            end,
            "﨧Annotations",
        },
    }, {
        prefix = "<leader>",
        mode = "n",
    })
end

return neogen_mod
