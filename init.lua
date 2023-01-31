loadfile(vim.fn.stdpath("cache") .. "/omega/highlights")()

require("omega.core.settings")

if vim.g.vscode then
else
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

    require("omega.core")
end
