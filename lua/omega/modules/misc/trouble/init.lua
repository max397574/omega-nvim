---@type OmegaModule
local trouble = {}

trouble.plugins = {
    ["trouble.nvim"] = {
        "folke/trouble.nvim",
        module = "trouble",
        cmd = {
            "Trouble",
            "TroubleClose",
            "TroubleToggle",
            "TroubleRefresh",
            "TodoTrouble",
        },
        config = function()
            require("omega.modules.misc.trouble.configs")["trouble.nvim"]()
        end,
    },
}

return trouble
