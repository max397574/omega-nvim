vim.g.mapleader = " "

_G.omega = {}

require("omega.core.autocommands")

require("omega.core.modules")
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("omega.core.commands")
        require("omega.core.mappings")
    end,
})
