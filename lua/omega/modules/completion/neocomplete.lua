---@type OmegaModule
local neocomplete = {}

neocomplete.plugins = {
    ["neocomplete.nvim"] = { "~/neovim_plugins/neocomplete.nvim/" },
}

neocomplete.configs = {
    ["neocomplete.nvim"] = function()
        require("neocomplete").setup()
    end,
}

return neocomplete
