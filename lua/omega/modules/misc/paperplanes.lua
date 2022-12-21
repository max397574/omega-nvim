---@type OmegaModule
local paperplanes = {}

paperplanes.configs = {
    ["paperplanes.nvim"] = function()
        require("paperplanes").setup({
            register = "+",
            provider = "paste.rs",
            -- provider = "ix.io",
        })
    end,
}

return paperplanes
