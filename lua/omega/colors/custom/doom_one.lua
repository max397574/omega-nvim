local theme = require("omega.colors.base16").themes(vim.g.colors_name)
local color_utils = require("omega.utils.colors")
local colors = require("omega.colors").get()
local config = require("omega.config").values
vim.g.terminal_color_4 = "#51afef"
vim.g.terminal_color_12 = "#51afef"
if config.cmp_theme == "border" then
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", {
        fg = colors.orange,
    })
    vim.api.nvim_set_hl(0, "CmpItemKindEvent", {
        fg = colors.pink,
    })
elseif config.cmp_theme == "no-border" then
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", {
        fg = colors.orange,
        bg = color_utils.blend_colors(colors.orange, theme.base00, 0.15),
    })
    vim.api.nvim_set_hl(0, "CmpItemKindMenuFunction", {
        fg = colors.orange,
    })
    vim.api.nvim_set_hl(0, "CmpItemKindBlockFunction", {
        fg = color_utils.blend_colors(colors.orange, theme.base00, 0.15),
    })
    vim.api.nvim_set_hl(0, "CmpItemKindEvent", {
        fg = colors.pink,
        bg = color_utils.blend_colors(colors.orange, theme.base00, 0.15),
    })
    vim.api.nvim_set_hl(0, "CmpItemKindMenuEvent", {
        fg = colors.pink,
    })
    vim.api.nvim_set_hl(0, "CmpItemKindBlockEvent", {
        fg = color_utils.blend_colors(colors.pink, theme.base00, 0.15),
    })
end

return {
    WarningMsg = { fg = colors.white },
    ErrorMsg = { fg = colors.white },
}
