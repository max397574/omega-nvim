local c = require("omega.colors.base16").themes(vim.g.colors_name)

return {
    Normal = { fg = c.base05, bg = c.base01 },
    Comment = { fg = c.base04 },
    ["@constant.builtin"] = { fg = c.base0F },
    ["@function"] = { fg = c.base0D },
    ["@function.builtin"] = { fg = c.base0D },
    ["@function.macro"] = { fg = c.base0D },
    ["@keyword"] = { fg = c.base09 },
    ["@keyword.function"] = { fg = c.base09 },
    ["@keyword.operator"] = { fg = c.base09 },
    ["@keyword.return"] = { fg = c.base09 },
    ["@parameter"] = { fg = c.base0E },
    ["@punctuation.bracket"] = { fg = c.base04 },
    ["@punctuation.delimiter"] = { fg = c.base04 },
    ["@punctuation.special"] = { fg = c.base0F },
    ["@string.escape"] = { fg = c.base0A },
    ["@variable"] = { fg = c.base0E },

    Conditional = { fg = c.base09 },
    Number = { fg = c.base0F },
    Operator = { fg = c.base0A },
    Type = { fg = c.base0C },

    NormalFloat = { bg = c.base01 },
    NvimTreeNormal = { bg = c.base00 },
    NvimTreeNormalNC = { bg = c.base00 },
    NvimTreeWinSeparator = { fg = c.base00, bg = c.base00 },

    CursorLineNr = { link = "Normal" },
    LineNr = { link = "Comment" },

    TBTabTitle = { link = "Normal" },
    TbLineTabCloseBtn = { link = "Normal" },
    TbLineTabOn = { link = "Normal" },
    TbLineBufOn = { link = "Normal" },
    TbLineBufOnClose = { link = "Normal" },
    TbLineBufOnModified = { link = "Normal" },
    TbLineCloseAllBufsBtn = { link = "Normal" },
}
