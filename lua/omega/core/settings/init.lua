---@diagnostic disable: assign-type-mismatch
local opt = vim.opt
local g = vim.g

opt.signcolumn = "yes:3"
opt.termguicolors = true
opt.cursorline = true -- highlight current line
opt.cmdheight = 0 -- height of cmd line
opt.conceallevel = 2
opt.relativenumber = true
opt.number = true
opt.undofile = true
opt.undodir = vim.fn.expand("~") .. "/.vim/undodir"
opt.foldlevel = 100

vim.defer_fn(function()
    opt.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20"
    opt.showmode = false
    vim.opt.fillchars = {
        eob = " ",
        vert = "║",
        horiz = "═",
        horizup = "╩",
        horizdown = "╦",
        vertleft = "╣",
        vertright = "╠",
        verthoriz = "╬",
    }
    opt.laststatus = 3
    opt.splitbelow = true
    opt.splitright = true
    opt.timeoutlen = 300
    opt.shiftwidth = 4
    opt.guifont = "Operator Mono Lig"
    opt.mouse = "nv"
    opt.ignorecase = true
    opt.smartcase = true
    opt.updatetime = 250
    opt.shortmess:append("c")
    opt.formatoptions = vim.opt.formatoptions
        + "r" -- continue comments after return
        + "c" -- wrap comments using textwidth
        + "q" -- allow to format comments w/ gq
        + "j" -- remove comment leader when joining lines when possible
        - "t" -- don't autoformat
        - "a" -- no autoformatting
        - "o" -- don't continue comments after o/O
        - "2" -- don't use indent of second line for rest of paragraph
    opt.jumpoptions:append("view")
    opt.virtualedit = "block" -- allow visual mode to go over end of lines
    opt.expandtab = true -- expand tabs to spaces
    opt.scrolloff = 3 -- start scrolling 3 lines away from top/bottom
    opt.compatible = false
    opt.wrap = true -- wrap long lines
    opt.linebreak = true
    opt.breakindent = true
    opt.showbreak = "  ﬌"
    opt.joinspaces = false
    opt.completeopt = "menuone,noselect"
    opt.lazyredraw = false -- Do not redraw screen while processing macros
    opt.list = true --show some hidden characters
    opt.listchars = {
        tab = "> ",
        nbsp = "␣",
        trail = "•",
    }
    opt.foldmethod = "expr" -- use treesitter for folding
    opt.foldexpr = "nvim_treesitter#foldexpr()"

    opt.grepprg = "rg --vimgrep --no-heading --smart-case"
    opt.grepformat:append("%f:%l:%c:%m")
end, 1)
