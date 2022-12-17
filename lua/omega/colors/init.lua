---@diagnostic disable: param-type-mismatch, redundant-parameter
local utils = require("omega.utils")
local colors = {}

function colors.create_colorscheme()
    local scheme = {}
    scheme.white = vim.fn.input("White> ", "")
    scheme.black = vim.fn.input("Background> ", "")
    scheme.darker_black = utils.darken_color(scheme.black, 6)
    scheme.black2 = utils.lighten_color(scheme.black, 6)
    scheme.one_bg = utils.lighten_color(scheme.black, 10)
    scheme.one_bg2 = utils.lighten_color(scheme.black, 19)
    scheme.one_bg3 = utils.lighten_color(scheme.black, 27)
    scheme.grey = utils.lighten_color(scheme.black, 40)
    scheme.grey_fg = utils.lighten_color(scheme.grey, 10)
    scheme.grey_fg2 = utils.lighten_color(scheme.grey, 20)
    scheme.light_grey = utils.lighten_color(scheme.grey, 28)
    scheme.red = vim.fn.input("Red> ", "")
    scheme.baby_pink = utils.lighten_color(scheme.red, 15)
    scheme.pink = vim.fn.input("Pink> ", "")
    scheme.purple = vim.fn.input("Purple> ", "")
    scheme.dark_purple = utils.darken_color(scheme.purple, 25)
    scheme.line = utils.lighten_color(scheme.black, 15)
    scheme.green = vim.fn.input("Green> ", "")
    scheme.dark_green = utils.darken_color(scheme.green, 25)
    scheme.vibrant_green = vim.fn.input("Vibrant Green> ", "")
    scheme.blue = vim.fn.input("Blue> ", "")
    scheme.orange = vim.fn.input("Orange> ", "")
    scheme.teal = vim.fn.input("Teal> ", "")
    scheme.cyan = vim.fn.input("Cyan> ", "")
    scheme.dark_blue = utils.darken_color(scheme.blue, 25)
    scheme.nord_blue = utils.darken_color(scheme.blue, 13)
    scheme.yellow = vim.fn.input("Yellow> ", "")
    scheme.sun = utils.lighten_color(scheme.yellow, 8)
    scheme.statusline_bg = utils.lighten_color(scheme.black, 4)
    scheme.lightbg = utils.lighten_color(scheme.statusline_bg, 13)
    scheme.lightbg2 = utils.lighten_color(scheme.statusline_bg, 7)
    scheme.pmenu_bg = scheme.darker_black
    scheme.folder_bg = scheme.blue
    return scheme
end

-- credits to https://github.com/EdenEast/nightfox.nvim
function colors.compile_theme()
    local highlights = require("omega.colors.highlights")
    local lines = {
        string.format(
            [[
require"omega.colors".compiled=string.dump(function()
vim.g.colors_name="%s"
        ]],
            vim.g.colors_name
        ),
    }
    for group, values in pairs(highlights) do
        local options = ""
        for optionname, value in pairs(values) do
            if type(value) == "boolean" then
                value = tostring(value)
            else
                value = '"' .. value .. '"'
            end
            options = options .. optionname .. "=" .. value .. ","
        end
        table.insert(lines, string.format([[vim.api.nvim_set_hl(0,"%s", {%s})]], group, options))
    end
    table.insert(lines, "end)")
    local highlight_file = vim.fn.stdpath("cache") .. "/omega/highlights"
    local file = io.open(highlight_file, "wb")
    if not file then
        print("error")
        return
    end
    loadstring(table.concat(lines, "\n"), "=")()
    file:write(require("omega.colors").compiled)
    file:close()
end

colors.init = function(theme, reload)
    reload = reload or false
    if not theme then
        if vim.g.forced_theme then
            theme = vim.g.forced_theme
        elseif vim.g.colors_name then
            theme = vim.g.colors_name
        end
    end
    vim.g.colors_name = theme

    -- local base16 = require("omega.colors.base16")
    --
    -- base16.apply_theme(base16.themes(theme))

    package.loaded["omega.colors.highlights" or false] = nil
    package.loaded["omega.colors.highlights"] = nil
    package.loaded["omega.colors.custom"] = nil
    loadfile(vim.fn.stdpath("cache") .. "/omega/highlights")()

    require("omega.colors.custom")
    if reload then
        local highlights_raw = vim.split(vim.api.nvim_exec("filter BufferLine hi", true), "\n")
        local highlight_groups = {}
        for _, raw_hi in ipairs(highlights_raw) do
            table.insert(highlight_groups, string.match(raw_hi, "BufferLine%a+"))
        end
        for _, highlight in ipairs(highlight_groups) do
            vim.cmd([[hi clear ]] .. highlight)
        end
        package.loaded["omega"] = nil
        package.loaded["bufferline"] = nil
        package.loaded["heirline"] = nil
        require("omega.modules.ui.bufferline").configs["bufferline.nvim"]()
        require("omega.modules.ui.heirline").configs["heirline.nvim"]()
        loadfile(vim.fn.stdpath("cache") .. "/omega/highlights")()
        require("omega.colors.custom")
        require("colorscheme_switcher").new_scheme()
    end
end

local config = require("omega.config").values
function colors.toggle_light()
    if vim.g.colors_name ~= config.light_colorscheme then
        omega.old_theme = vim.g.colors_name
        colors.init(config.light_colorscheme, true)
        vim.g.toggle_icon = " "
    else
        colors.init(omega.old_theme, true)
        vim.g.toggle_icon = " "
    end
end

-- returns a table of colors for givem or current theme
colors.get = function(theme)
    if not theme then
        theme = vim.g.colors_name
    end
    if theme == "nil" or theme == nil then
        theme = config.colorscheme
    end
    return require("hl_themes." .. theme)
end

return colors
