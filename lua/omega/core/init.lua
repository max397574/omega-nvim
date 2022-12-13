vim.g.mapleader = " "

require("omega.core.config").load()

local modules = require("omega.core.modules")

local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.isdirectory(packer_path) == 0 then
    vim.notify("Bootstrapping packer.nvim, please wait ...")
    vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        packer_path,
    })
end

vim.cmd.packadd("packer.nvim")

-- HACK: prevent packer from ever doing autocmd BufRead
_G._packer = setmetatable(_G._packer or {}, {
    __index = function(_, key)
        if key == "needs_bufread" then
            return false
        end

        return rawget(_G._packer, key)
    end,
    __newindex = function(t, k, v)
        if k == "needs_bufread" then
            return
        end
        rawset(t, k, v)
    end,
})

local wk_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/which-key.nvim"
if vim.fn.empty(vim.fn.glob(wk_path)) > 0 then
    vim.notify("Bootstrapping which-key.nvim, please wait ...")
    vim.fn.system({
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/max397574/which-key.nvim",
        wk_path,
    })
end

vim.cmd.packadd("which-key.nvim")

require("omega.core.settings")
require("omega.core.autocommands")
require("omega.core.commands")
require("omega.core.ui")

modules.setup()
modules.load()
