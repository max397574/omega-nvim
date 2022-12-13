vim.defer_fn(function()
    require("impatient")
end, 0)

-- dofile(vim.fn.expand("~") .. "/neovim_plugins/profiler.nvim/lua/profiler.lua")
_G.omega = {}

omega.load_treesitter = not vim.tbl_contains({ "[packer]", "" }, vim.fn.expand("%"))

omega.modules = {}
omega.plugin_configs = {}

require("omega.core")
