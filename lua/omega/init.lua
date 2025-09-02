local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "omega.modules" },
    },
    defaults = {
        lazy = true,
        version = false,
    },
    dev = {
        patterns = { "max397574" },
        path = "~/4_ComputerScience/1_Programming/neovim_plugins/",
    },
})
vim.cmd.packadd("nvim.undotree")

require("omega.options")
require("omega.autocommands")
require("omega.commands")
require("omega.keymappings")
require("textobject_dollar")
