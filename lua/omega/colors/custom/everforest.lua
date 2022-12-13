local colors = require("omega.colors").get()
vim.g.terminal_color_foreground = colors.white

return {
    ["Visual"] = { bg = colors.light_grey },
    ["CursorLine"] = { bg = colors.light_grey },
    ["FloatBorder"] = { fg = colors.light_grey },
    ["CmpCompletionWindowBorder"] = { fg = colors.light_grey },
    ["CmpDocumentationWindowBorder"] = { fg = colors.light_grey },
    ["WinSeparator"] = { fg = colors.light_grey },
}
