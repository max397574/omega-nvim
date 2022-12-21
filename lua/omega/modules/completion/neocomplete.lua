---@type OmegaModule
local neocomplete = {}

neocomplete.configs = {
    ["neocomplete.nvim"] = function()
        require("neocomplete").setup()
    end,
}

return neocomplete
