-- vim.g.mapleader = " "
--
-- require("omega.core.omega_global")
-- require("omega.core.config").load()
--
-- local modules = require("omega.core.modules")
--
-- local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
-- if vim.fn.isdirectory(packer_path) == 0 then
--     vim.notify("Bootstrapping packer.nvim, please wait ...")
--     vim.fn.system({
--         "git",
--         "clone",
--         "--depth",
--         "1",
--         "https://github.com/wbthomason/packer.nvim",
--         packer_path,
--     })
-- end
--
-- vim.cmd.packadd("packer.nvim")
-- local wk_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/which-key.nvim"
-- if vim.fn.empty(vim.fn.glob(wk_path)) > 0 then
--     vim.notify("Bootstrapping which-key.nvim, please wait ...")
--     vim.fn.system({
--         "git",
--         "clone",
--         "--depth",
--         "1",
--         "https://github.com/max397574/which-key.nvim",
--         wk_path,
--     })
-- end
--
-- vim.cmd.packadd("which-key.nvim")
--
-- require("omega.core.settings")
-- require("omega.core.autocommands")
-- require("omega.core.commands")
-- require("omega.core.ui")
--
-- modules.setup()
-- modules.load()
--
-- require("omega.core.mappings")
vim.g.mapleader = " "

require("omega.core.omega_global")
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
local wk_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/which-key.nvim"
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
