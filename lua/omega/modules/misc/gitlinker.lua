---@type OmegaModule
local gitlinker = {}

gitlinker.plugins = {
    ["gitlinker.nvim"] = {
        "ruifm/gitlinker.nvim",
        keys = { "<leader>gy" },
    },
}

gitlinker.configs = {
    ["gitlinker.nvim"] = function()
        require("gitlinker").setup()
    end,
}

return gitlinker
