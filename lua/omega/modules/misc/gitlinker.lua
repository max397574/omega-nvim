---@type OmegaModule
local gitlinker = {}

gitlinker.configs = {
    ["gitlinker.nvim"] = function()
        require("gitlinker").setup()
    end,
}

return gitlinker
