local config = require("omega.config").values

local colors = require("omega.colors").get(vim.g.colors_name)
local theme = require("omega.colors.base16").themes(vim.g.colors_name)

local black = colors.black
local black2 = colors.black2
local blue = colors.blue
local darker_black = colors.darker_black
local folder_bg = colors.folder_bg
local green = colors.green
local grey = colors.grey
local grey_fg = colors.grey_fg
local line = colors.line
local light_grey = colors.light_grey
local nord_blue = colors.nord_blue
local one_bg = colors.one_bg
local one_bg2 = colors.one_bg2
local pmenu_bg = colors.pmenu_bg
local purple = colors.purple
local red = colors.red
local white = colors.white
local yellow = colors.yellow
local orange = colors.orange
local tele_bg = colors.telescope_bg or colors.darker_black
local tele_prompt = colors.telescope_prompt or colors.black2

-- Comments
local highlights = {
    ["Normal"] = { fg = theme.base05, bg = theme.base00 },
    ["Bold"] = { bold = true },
    ["Debug"] = { fg = theme.base08 },
    ["Directory"] = { fg = theme.base0D },
    ["Error"] = { fg = theme.base00, bg = theme.base08 },
    ["ErrorMsg"] = { fg = theme.base08, bg = theme.base00 },
    ["Exception"] = { fg = theme.base08 },
    ["FoldColumn"] = { fg = theme.base0C, bg = theme.base01 },
    ["CurSearch"] = { fg = theme.base01, bg = theme.base09 },
    ["Italic"] = { italic = true },
    ["Macro"] = { fg = theme.base08, italic = true },
    ["MatchParen"] = { bold = true },
    ["ModeMsg"] = { fg = theme.base0B },
    ["MoreMsg"] = { fg = theme.base0B },
    ["Question"] = { fg = theme.base0D },
    ["Substitute"] = { fg = theme.base01, bg = theme.base0A },
    ["SpecialKey"] = { fg = theme.base03 },
    ["TooLong"] = { fg = theme.base08 },
    ["Underlined"] = { fg = theme.base08 },
    ["Visual"] = { bg = theme.base02 },
    ["VisualNOS"] = { fg = theme.base08 },
    ["WarningMsg"] = { fg = theme.base08 },
    ["WildMenu"] = { fg = theme.base08, bg = theme.base0A },
    ["Title"] = { fg = theme.base0D },
    ["Conceal"] = {},
    ["Cursor"] = { fg = theme.base00, bg = theme.base05 },
    ["NonText"] = { fg = theme.base03 },
    ["NeorgMarkupVerbatim"] = { fg = theme.base03 },
    ["SignColumn"] = { fg = theme.base03 },
    ["StatusLine"] = { fg = theme.base04 },
    ["StatusLineNC"] = { fg = theme.base03 },
    ["ColorColumn"] = { bg = theme.base01 },
    ["CursorColumn"] = { bg = theme.base01 },
    ["CursorLine"] = { bg = theme.base01 },
    ["CursorLineNr"] = { fg = theme.base04 },
    ["QuickFixLine"] = { bg = theme.base01 },
    ["TabLine"] = { fg = theme.base03, bg = theme.base01 },
    ["TabLineFill"] = { fg = theme.base03, bg = theme.base01 },
    ["TabLineSel"] = { fg = theme.base0B, bg = theme.base01 },
    ["Boolean"] = { fg = theme.base09 },
    ["Character"] = { fg = theme.base08 },
    ["Conditional"] = { fg = theme.base0E, italic = true },
    ["Constant"] = { fg = theme.base09 },
    ["Define"] = { fg = theme.base0E },
    ["Delimiter"] = { fg = theme.base0F },
    ["Float"] = { fg = theme.base09 },
    ["Identifier"] = { fg = theme.base08 },
    ["Include"] = { fg = theme.base0D },
    ["Label"] = { fg = theme.base0A },
    ["Number"] = { fg = theme.base09 },
    ["Operator"] = { fg = theme.base05 },
    ["PreProc"] = { fg = theme.base0A },
    ["Repeat"] = { fg = theme.base0A },
    ["SpecialChar"] = { fg = theme.base0F },
    ["Statement"] = { fg = theme.base08 },
    ["StorageClass"] = { fg = theme.base0A },
    ["String"] = { fg = theme.base0B },
    ["Structure"] = { fg = theme.base0E },
    ["Tag"] = { fg = theme.base0A },
    ["Todo"] = { fg = theme.base0A, bg = theme.base01 },
    ["Type"] = { fg = theme.base0A },
    ["Typedef"] = { fg = theme.base0A },
    ["DiffDelete"] = { fg = theme.base08, bg = theme.base01 },
    ["DiffText"] = { fg = theme.base0D, bg = theme.base01 },
    ["DiffAdded"] = { fg = theme.base0B, bg = theme.base00 },
    ["DiffFile"] = { fg = theme.base08, bg = theme.base00 },
    ["DiffNewFile"] = { fg = theme.base0B, bg = theme.base00 },
    ["DiffLine"] = { fg = theme.base0D, bg = theme.base00 },
    ["DiffRemoved"] = { fg = theme.base08, bg = theme.base00 },
    ["gitcommitOverflow"] = { fg = theme.base08 },
    ["gitcommitSummary"] = { fg = theme.base0B },
    ["gitcommitComment"] = { fg = theme.base03 },
    ["gitcommitUntracked"] = { fg = theme.base03 },
    ["gitcommitDiscarded"] = { fg = theme.base03 },
    ["gitcommitSelected"] = { fg = theme.base03 },
    ["gitcommitHeader"] = { fg = theme.base0E },
    ["gitcommitSelectedType"] = { fg = theme.base0D },
    ["gitcommitUnmergedType"] = { fg = theme.base0D },
    ["gitcommitDiscardedType"] = { fg = theme.base0D },
    ["gitcommitBranch"] = { fg = theme.base09, bold = true },
    ["gitcommitUntrackedFile"] = { fg = theme.base0A },
    ["gitcommitUnmergedFile"] = { fg = theme.base08, bold = true },
    ["gitcommitDiscardedFile"] = { fg = theme.base08, bold = true },
    ["gitcommitSelectedFile"] = { fg = theme.base0B, bold = true },
    ["mailQuoted1"] = { fg = theme.base0A },
    ["mailQuoted2"] = { fg = theme.base0B },
    ["mailQuoted3"] = { fg = theme.base0E },
    ["mailQuoted4"] = { fg = theme.base0C },
    ["mailQuoted5"] = { fg = theme.base0D },
    ["mailQuoted6"] = { fg = theme.base0A },
    ["mailURL"] = { fg = theme.base0D },
    ["mailEmail"] = { fg = theme.base0D },
    ["SpellLocal"] = { undercurl = true, sp = theme.base0C },
    ["SpellCap"] = { undercurl = true, sp = theme.base0D },
    ["SpellRare"] = { undercurl = true, sp = theme.base0E },
    ["@comment"] = { fg = theme.base03, italic = true },
    ["@error"] = { fg = theme.base08 },
    ["@none"] = { fg = theme.base05 },
    ["@preproc"] = { fg = theme.base0A },
    ["@define"] = { fg = theme.base0A },
    ["@operator"] = { fg = theme.base05 },
    ["@punctuation.delimiter"] = { fg = theme.base0F },
    ["@puncuation.bracket"] = { fg = theme.base0D },
    ["@punctuation.special"] = { fg = theme.base05 },
    ["@string"] = { fg = theme.base0B },
    ["@string.regex"] = { fg = theme.base0C },
    ["@string.escape"] = { fg = theme.base0C },
    ["@string.special"] = { fg = theme.base0C },
    ["@character"] = { fg = theme.base08 },
    ["@character.special"] = { fg = theme.base0F },
    ["@boolean"] = { fg = theme.base09 },
    ["@number"] = { fg = theme.base09 },
    ["@float"] = { fg = theme.base09 },
    ["@function"] = { fg = theme.base0D, italic = true },
    ["@function.builtin"] = { fg = theme.base0D },
    ["@function.call"] = { fg = theme.base0D },
    ["@function.macro"] = { fg = theme.base08 },
    ["@method"] = { fg = theme.base0D, italic = true },
    ["@method.call"] = { fg = theme.base0D },
    ["@constructor"] = { fg = theme.base0C },
    ["@parameter"] = { fg = theme.base08 },
    ["@keyword"] = { fg = theme.base0E },
    ["@keyword.function"] = { fg = theme.base0E },
    ["@keyword.operator"] = { fg = theme.base0E },
    ["@keyword.return"] = { fg = theme.base0E },
    ["@conditional"] = { fg = theme.base0E, italic = true },
    ["@repeat"] = { fg = theme.base0A },
    ["@debug"] = { fg = theme.base08 },
    ["@label"] = { fg = theme.base0A },
    ["@include"] = { fg = theme.base0D },
    ["@exception"] = { fg = theme.base08 },
    ["@type"] = { fg = theme.base0A },
    ["@type.builtin"] = { fg = theme.base0A },
    ["@type.definition"] = { fg = theme.base0A },
    ["@type.qualifier"] = { fg = theme.base0A },
    ["@storageclass"] = { fg = theme.base0A },
    ["@attribute"] = { fg = theme.base0A },
    ["@field"] = { fg = theme.base08 },
    ["@property"] = { fg = theme.base08 },
    ["@variable"] = { fg = theme.base05 },
    ["@variable.builtin"] = { fg = theme.base09 },
    ["@constant"] = { fg = theme.base09 },
    ["@constant.builtin"] = { fg = theme.base09 },
    ["@constant.macro"] = { fg = theme.base08 },
    ["@namespace"] = { fg = theme.base08 },
    ["@symbol"] = { fg = theme.base0B },
    ["@text"] = { fg = theme.base05 },
    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { fg = theme.base09, italic = true },
    ["@text.underline"] = { fg = theme.base05, underline = true },
    ["@text.strike"] = { fg = theme.base05, strikethrough = true },
    ["@text.title"] = { bold = true, underline = true },
    ["@text.literal"] = { fg = theme.base09 },
    ["@text.uri"] = { fg = theme.base09, underline = true },
    ["@text.math"] = { fg = theme.base0C },
    ["@text.environment"] = { fg = theme.base0D },
    ["@text.environment.name"] = { fg = theme.base05, italic = true },
    ["@text.reference"] = { fg = theme.base09 },
    ["@text.todo"] = { fg = theme.base0A, bg = theme.base01 },
    ["@text.note"] = { fg = theme.base0D, bg = theme.base01 },
    ["@text.warning"] = { fg = theme.base0A, bg = theme.base01 },
    ["@text.danger"] = { fg = theme.base0F, bg = theme.base01 },
    ["@text.diff.add"] = { fg = theme.base0B },
    ["@text.diff.delete"] = { fg = theme.base08 },
    ["@tag"] = { fg = theme.base0A },
    ["@tag.attribute"] = { fg = theme.base0A },
    ["@tag.delimiter"] = { fg = theme.base0F },
    ["@conceal"] = { fg = theme.base05 },
    ["@definition"] = { underline = true, sp = theme.base04 },
    ["@scope"] = { bold = true },
    ["TSAnnotation"] = { fg = theme.base0F },
    ["TSError"] = { fg = theme.base08 },
    ["TSParameterReference"] = { fg = theme.base05 },
    ["TSPunctDelimiter"] = { fg = theme.base0F },
    ["LspDiagnosticsDefaultError"] = { fg = theme.base08 },
    ["LspDiagnosticsDefaultWarning"] = { fg = theme.base0A },
    ["LspDiagnosticsDefaultWarn"] = { fg = theme.base0A },
    ["LspDiagnosticsDefaultInformation"] = { fg = theme.base0D },
    ["LspDiagnosticsDefaultInfo"] = { fg = theme.base0D },
    ["LspDiagnosticsDefaultHint"] = { fg = theme.base0C },
    ["TelescopeNormal"] = { fg = theme.base05, bg = theme.base00 },
    ["TelescopePreviewNormal"] = { fg = theme.base05, bg = theme.base00 },
    ["Keyword"] = { fg = theme.base0E, italic = true },
    ["PMenu"] = { fg = theme.base05, bg = theme.base00 },
    ["Special"] = { fg = theme.base0C, italic = true },
    ["markdownBold"] = { fg = theme.base0A, bold = true },
    ["@quantifier"] = { fg = theme.base0C, italic = true },
    ["@require_call"] = { fg = theme.base0E, italic = true },
    ["@utils"] = { fg = theme.base0D },
    ["@code"] = { fg = theme.base03 },
    ["@rust_path"] = { fg = theme.base0B },
    ["CodeActionAvailable"] = { fg = theme.base08 },

    Comment = { fg = grey_fg, italic = true },
    TS_Context = { bg = grey_fg },
    Yellow = { fg = yellow },
    Red = { fg = red },
    Green = { fg = green },
    EndOfBuffer = { fg = black },
    NormalFloat = {},

    DiagnosticWarn = { fg = orange },
    DiagnosticError = { fg = red },
    DiagnosticInfo = { fg = yellow },
    DiagnosticHint = { fg = blue },

    SpellBad = { undercurl = true, sp = red },

    PmenuSbar = { bg = one_bg2 },

    LineNr = { fg = grey },
    NvimInternalError = { fg = red },
    VertSplit = { fg = one_bg2 },

    PmenuThumb = { bg = white },
    WinSeparator = { fg = one_bg2 },
    CmpDocumentationWindowBorder = { fg = one_bg2 },

    NeorgCodeBlock = { bg = darker_black },

    Folded = {},

    DashboardHeader = { fg = grey_fg },
    DashboardFooter = { fg = grey_fg },
    DashboardCenter = { fg = grey_fg },
    DashboardShortcut = { fg = grey_fg },

    DiffAdd = { fg = nord_blue },
    DiffChange = { fg = grey_fg },
    DiffModified = { fg = nord_blue },

    IndentBlanklineChar = { fg = line },

    LspDiagnosticsSignError = { fg = red },
    LspDiagnosticsSignWarning = { fg = yellow },
    LspDiagnosticsVirtualTextError = { fg = red },
    LspDiagnosticsVirtualTextWarning = { fg = yellow },

    LspDiagnosticsSignInformation = { fg = green },
    LspDiagnosticsVirtualTextInformation = { fg = green },
    LspDiagnosticsSignHint = { fg = purple },
    LspDiagnosticsVirtualTextHint = { fg = purple },
    NotifyERRORBorder = { fg = red },
    NotifyERRORIcon = { fg = red },
    NotifyERRORTitle = { fg = red },
    NotifyWARNBorder = { fg = orange },
    NotifyWARNIcon = { fg = orange },
    NotifyWARNTitle = { fg = orange },
    NotifyINFOBorder = { fg = green },
    NotifyINFOIcon = { fg = green },
    NotifyINFOTitle = { fg = green },
    NotifyDEBUGBorder = { fg = grey },
    NotifyDEBUGIcon = { fg = grey },
    NotifyDEBUGTitle = { fg = grey },
    NotifyTRACEBorder = { fg = purple },
    NotifyTRACEIcon = { fg = purple },
    NotifyTRACETitle = { fg = purple },
    NvimTreeEmptyFolderName = { fg = blue },
    NvimTreeEndOfBuffer = { fg = darker_black },
    NvimTreeFolderIcon = { fg = folder_bg },
    NvimTreeFolderName = { fg = folder_bg },
    NvimTreeGitDirty = { fg = red },
    NvimTreeIndentMarker = { fg = one_bg2 },
    NvimTreeNormal = { bg = darker_black },
    NvimTreeOpenedFolderName = { fg = blue },
    NvimTreeRootFolder = { fg = red, underline = true },
    NvimTreeStatuslineNc = { fg = darker_black, bg = darker_black },
    NvimTreeVertSplit = { fg = darker_black, bg = darker_black },
    NvimTreeWindowPicker = { fg = red, bg = tele_prompt },

    Search = { bg = yellow },
    IncSearch = { bg = red },

    TelescopeBorder = { fg = folder_bg },

    LspReferenceRead = { link = "Visual" },
    LspReferenceText = { link = "Visual" },
    LspReferenceWrite = { link = "Visual" },

    LightspeedLabel = { fg = "#7DB000" },
    LightspeedShortcut = { bg = "#7DB000" },
    LightspeedOneCharMatch = { bg = "#7DB000" },
    LightspeedUniqueChar = { fg = "#FF6000" },
    LightspeedUnlabeledMatch = { fg = "#FF6000" },

    Definition = { fg = colors.white, bg = colors.darker_black },
    FloatBorder = { fg = light_grey, bg = black },

    PmenuSel = { fg = colors.blue, bg = colors.light_grey },

    LspSignatureActiveParameter = { bold = true, italic = true },

    NoicePopup = { bg = darker_black },
    LazyH1 = {
        bg = colors.green,
        fg = colors.black,
    },

    LazyButton = {
        bg = colors.one_bg,
        fg = require("omega.utils").lighten_color(colors.light_grey, 10),
    },

    LazyH2 = {
        fg = colors.red,
        bold = true,
        underline = true,
    },

    LazyReasonPlugin = { fg = colors.red },
    LazyValue = { fg = colors.teal },
    LazyDir = { fg = theme.base05 },
    LazyUrl = { fg = theme.base05 },
    LazyCommit = { fg = colors.green },
    LazyNoCond = { fg = colors.red },
    LazySpecial = { fg = colors.blue },
    LazyReasonFt = { fg = colors.purple },
    LazyOperator = { fg = colors.white },
    LazyReasonKeys = { fg = colors.teal },
    LazyTaskOutput = { fg = colors.white },
    LazyCommitIssue = { fg = colors.pink },
    LazyReasonEvent = { fg = colors.yellow },
    LazyReasonStart = { fg = colors.white },
    LazyReasonRuntime = { fg = colors.nord_blue },
    LazyReasonCmd = { fg = colors.sun },
    LazyReasonSource = { fg = colors.cyan },
    LazyReasonImport = { fg = colors.white },
    LazyProgressDone = { fg = colors.green },
}

local kind_highlights = {
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
    Function = theme.base0D,
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
}
local color_utils = require("omega.utils.colors")
for kind_name, hl in pairs(kind_highlights) do
    if config.cmp_theme == "border" then
        highlights[("CmpItemKind%s"):format(kind_name)] = { fg = hl }
    elseif config.cmp_theme == "no-border" then
        highlights[("CmpItemKind%s"):format(kind_name)] = {
            fg = hl,
            bg = color_utils.blend_colors(hl, theme.base00, 0.15),
        }
        highlights[("CmpItemKindMenu%s"):format(kind_name)] = { fg = hl }
        highlights[("CmpItemKindBlock%s"):format(kind_name)] =
            { fg = color_utils.blend_colors(hl, theme.base00, 0.15) }
    end
end

if config.cmp_theme == "no-border" then
    highlights.Pmenu = { fg = white, bg = darker_black }
    highlights.CmpBorder = { fg = darker_black, bg = black }
elseif config.cmp_theme == "border" then
    highlights.CmpBorder = { fg = white }
end

if config.telescope_highlights == "custom_bottom_no_borders" then
    highlights.TelescopeBorder = { fg = tele_bg, bg = tele_bg }
    highlights.TelescopePromptBorder = { fg = tele_prompt, bg = tele_prompt }
    highlights.TelescopePreviewBorder = { fg = tele_bg, bg = tele_bg }
    highlights.TelescopeResultsBorder = { fg = tele_bg, bg = tele_bg }
    highlights.TelescopePromptNormal = { fg = white, bg = tele_prompt }
    highlights.TelescopePromptPrefix = { fg = red, bg = tele_prompt }
    highlights.TelescopePreviewTitle = { fg = black, bg = green }
    highlights.TelescopePromptTitle = { fg = black, bg = red }
    highlights.TelescopeResultsTitle = { fg = black, bg = blue }
    highlights.TelescopeSelection = { fg = blue, bg = light_grey }
    highlights.TelescopeSelectionCaret = { fg = blue, bg = light_grey }

    highlights.TelescopeNormal = { bg = tele_bg }
    highlights.TelescopePreviewNormal = { bg = tele_bg }
    highlights.TelescopePreviewLine = { bg = light_grey }
elseif config.telescope_theme == "float_all_borders" then
    highlights.TelescopeBorder = { fg = light_grey, bg = black }
    highlights.TelescopePromptBorder = { fg = light_grey, bg = black }
    highlights.TelescopePreviewBorder = { fg = light_grey, bg = black }
    highlights.TelescopeResultsBorder = { fg = light_grey, bg = black }
    highlights.TelescopePromptNormal = { fg = white }
    highlights.TelescopePromptPrefix = { fg = red }
    highlights.TelescopePreviewTitle = { fg = black, bg = green }
    highlights.TelescopePromptTitle = { fg = black, bg = red }
    highlights.TelescopeResultsTitle = { fg = black, bg = blue }
    highlights.TelescopeSelection = { fg = blue, bg = light_grey }
    highlights.TelescopeSelectionCaret = { fg = blue, bg = light_grey }

    highlights.TelescopeNormal = { bg = black }
    highlights.TelescopePreviewNormal = { bg = black }
    highlights.TelescopePreviewLine = { bg = light_grey }
end

return highlights
