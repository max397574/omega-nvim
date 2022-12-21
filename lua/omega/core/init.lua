vim.g.mapleader = " "

_G.omega = {}

require("omega.core.settings")
require("omega.core.autocommands")
-- require("omega.colors").init(require("omega.config").values.colorscheme)

require("omega.core.modules")
vim.defer_fn(function()
    vim.defer_fn(function()
        require("omega.core.commands")
    end, 1)
end, 0)
