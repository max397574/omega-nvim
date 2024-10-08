local data = {}
local theme = require("omega.colors.themes." .. vim.g.colors_name).base16
local colors = require("omega.colors.themes." .. vim.g.colors_name).colors

data.mode_colors = {
    n = colors.red,
    i = colors.green,
    v = colors.purple,
    V = colors.purple,
    ["^V"] = colors.blue,
    c = colors.red,
    s = colors.yellow,
    S = colors.yellow,
    ["^S"] = colors.yellow,
    R = colors.purple,
    r = colors.purple,
    ["!"] = colors.purple,
    t = colors.purple,
}

data.mode_icons = {
    ["n"] = "  ",
    ["i"] = " 󰏫 ",
    ["s"] = " 󰏫 ",
    ["S"] = " 󰏫 ",
    [""] = " 󰏫 ",

    ["v"] = " 󰈈 ",
    ["V"] = "  ",
    [""] = " 󰈈 ",
    ["r"] = " 󰛔 ",
    ["r?"] = "  ",
    ["c"] = "  ",
    ["t"] = "  ",
    ["!"] = "  ",
    ["R"] = "  ",
}

data.file_icons = {
    typescript = " ",
    json = " ",
    jsonc = " ",
    tex = " ",
    ts = " ",
    python = " ",
    py = " ",
    java = " ",
    html = " ",
    css = " ",
    scss = " ",
    javascript = " ",
    js = " ",
    javascriptreact = " ",
    markdown = " ",
    md = " ",
    sh = " ",
    zsh = " ",
    vim = " ",
    rust = " ",
    rs = " ",
    cpp = " ",
    c = " ",
    go = " ",
    lua = " ",
    conf = " ",
    haskel = " ",
    hs = " ",
    ruby = " ",
    norg = " ",
    txt = " ",
}

data.kind_highlight = {
    Class = theme.base08,
    Color = theme.base08,
    Constant = theme.base09,
    Constructor = theme.base08,
    Enum = theme.base08,
    EnumMember = theme.base08,
    Event = theme.base0D,
    Field = theme.base08,
    File = theme.base09,
    Folder = theme.base09,
    Number = theme.base09,
    Boolean = theme.base09,
    Function = theme.base0D,
    Package = theme.base0D,
    Interface = theme.base0D,
    Keyword = theme.base0E,
    Method = theme.base08,
    Module = theme.base08,
    Operator = theme.base08,
    Property = theme.base0A,
    Reference = theme.base08,
    Snippet = theme.base0C,
    Struct = theme.base08,
    Text = theme.base0B,
    TypeParameter = theme.base08,
    Type = theme.base0A,
    Unit = theme.base08,
    Value = theme.base08,
    Variable = theme.base0E,
    Structure = theme.base0E,
    Identifier = theme.base08,
    Namespace = theme.base08,
    String = theme.base0B,
    Array = theme.base0B,
    Object = theme.base0A,
    Key = theme.base0E,
    Null = colors.grey_fg,
}

return data
