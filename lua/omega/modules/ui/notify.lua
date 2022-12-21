---@type OmegaModule
local notify = {}

notify.configs = {
    ["nvim-notify"] = function()
        local colors = require("omega.colors").get()
        require("notify").setup({ background_color = colors.black })
    end,
}

return notify
