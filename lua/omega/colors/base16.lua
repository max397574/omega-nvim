local config = require("omega.config").values

local base16 = {}

base16.themes = function(theme)
    if not theme then
        theme = vim.g.colors_name
    end
    if theme == "nil" or theme == nil then
        theme = config.colorscheme
    end
    return require("themes." .. theme .. "-base16")
end
return base16
