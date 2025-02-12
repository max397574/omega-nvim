local profile = false
if profile then
    local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup({
        startup = {
            event = "UIEnter",
        },
    })
end

vim.loader.enable()
vim.g.mapleader = " "
vim.g.maplocalleader = ","
require("omega")
