vim.o.splitbelow = true
vim.o.splitright = true
vim.o.timeoutlen = 300
vim.o.shiftwidth = 4
vim.o.relativenumber = true
vim.o.guifont = "Operator Mono Lig"
vim.o.number = true
vim.o.termguicolors = true
vim.o.mouse = "nv"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes:3"
vim.o.undofile = true
vim.o.undodir = vim.fn.expand("~") .. "/.vim/undodir" -- directory to save undofiles
vim.o.updatetime = 250
vim.opt.shortmess:append("c")
vim.opt.formatoptions = vim.opt.formatoptions
    + "r" -- continue comments after return
    + "c" -- wrap comments using textwidth
    + "q" -- allow to format comments w/ gq
    + "j" -- remove comment leader when joining lines when possible
    - "t" -- don't autoformat
    - "a" -- no autoformatting
    - "o" -- don't continue comments after o/O
    - "2" -- don't use indent of second line for rest of paragraph
vim.o.cmdheight = 0 -- height of cmd line
vim.opt.jumpoptions:append("view")
vim.o.virtualedit = "block" -- allow visual mode to go over end of lines
vim.o.expandtab = true -- expand tabs to spaces
vim.o.showmode = false -- don't show mode (I've lualine)
vim.o.scrolloff = 3 -- start scrolling 3 lines away from top/bottom
vim.o.cursorline = true -- highlight current line
vim.o.compatible = false
vim.o.wrap = true -- wrap long lines
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.showbreak = "  ﬌"
vim.o.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20"
vim.o.foldlevel = 100
vim.o.joinspaces = false
vim.o.completeopt = "menuone,noselect"
vim.o.conceallevel = 2
vim.o.lazyredraw = true -- Do not redraw screen while processing macros
vim.o.list = true --show some hidden characters
vim.opt.listchars = {
    tab = "> ",
    nbsp = "␣",
    trail = "•",
}
vim.opt.foldmethod = "expr" -- use treesitter for folding
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
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
vim.opt.laststatus = 3

vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.grepformat:append("%f:%l:%c:%m")

-- disable builtin plugins for faster startuptime
vim.g.loaded_python3_provider = 1
vim.g.loaded_python_provider = 1
vim.g.loaded_node_provider = 1
vim.g.loaded_ruby_provider = 1
vim.g.loaded_perl_provider = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor = 1
vim.g.loaded_rplugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1
vim.g.loaded_syntax = 1
vim.g.loaded_synmenu = 1
vim.g.loaded_optwin = 1
vim.g.loaded_compiler = 1
vim.g.loaded_bugreport = 1
vim.g.loaded_ftplugin = 1
vim.g.did_load_ftplugin = 1
vim.g.did_indent_on = 1
