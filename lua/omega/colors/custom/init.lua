local theme = require("omega.config").values.colorscheme

local ok, highlights = pcall(require, "omega.colors.custom." .. theme)

-- local highlights = require("custom_highlights." .. vim.g.colors_name)
if ok then
    for hl, attr in pairs(highlights) do
        vim.api.nvim_set_hl(0, hl, attr)
    end
end
