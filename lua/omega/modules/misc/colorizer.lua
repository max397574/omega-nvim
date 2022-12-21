---@type OmegaModule
local colorizer = {}

colorizer.configs = {
    ["nvim-colorizer.lua"] = function()
        require("colorizer").setup({
            "*",
        }, {
            mode = "foreground",
            hsl_fn = true,
        })
        vim.cmd.ColorizerAttachToBuffer()
    end,
}

return colorizer
