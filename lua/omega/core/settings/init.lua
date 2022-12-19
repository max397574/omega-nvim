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
    opt.foldlevel = 100
    opt.joinspaces = false
    opt.completeopt = "menuone,noselect"
    opt.lazyredraw = false -- Do not redraw screen while processing macros
    opt.list = true --show some hidden characters
    opt.listchars = {
        tab = "> ",
        nbsp = "␣",
        trail = "•",
    }
    vim.opt.foldmethod = "expr" -- use treesitter for folding
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
    vim.opt.grepformat:append("%f:%l:%c:%m")

    -- disable builtin plugins for faster startuptime
    g.loaded_python3_provider = 1
    g.loaded_python_provider = 1
    g.loaded_node_provider = 1
    g.loaded_ruby_provider = 1
    g.loaded_perl_provider = 1
    g.loaded_2html_plugin = 1
    g.loaded_getscript = 1
    g.loaded_getscriptPlugin = 1
    g.loaded_gzip = 1
    g.loaded_tar = 1
    g.loaded_tarPlugin = 1
    g.loaded_rrhelper = 1
    g.loaded_vimball = 1
    g.loaded_vimballPlugin = 1
    g.loaded_zip = 1
    g.loaded_zipPlugin = 1
    g.loaded_tutor = 1
    g.loaded_rplugin = 1
    g.loaded_logiPat = 1
    g.loaded_netrwSettings = 1
    g.loaded_netrwFileHandlers = 1
    g.loaded_syntax = 1
    g.loaded_synmenu = 1
    g.loaded_optwin = 1
    g.loaded_compiler = 1
    g.loaded_bugreport = 1
    g.loaded_ftplugin = 1
    g.did_load_ftplugin = 1
    g.did_indent_on = 1
    g.loaded_netrwPlugin = 1
end, 1)
