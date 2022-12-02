---@type OmegaModule
local colorizer = {}

colorizer.plugins = {
    ["nvim-colorizer.lua"] = {
        "xiyaowong/nvim-colorizer.lua",
        cmd = { "ColorizerAttachToBuffer" },
    },
}
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
