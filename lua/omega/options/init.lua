local opt = vim.opt

opt.undofile = true
opt.undodir = vim.fn.expand("~") .. "/.vim/undodir"
opt.scrolloff = 3 -- start scrolling 3 lines away from top/bottom
opt.shiftwidth = 4
require("omega.options.ui")
vim.defer_fn(function()
    opt.timeoutlen = 300
    opt.mouse = "nv"
    opt.ignorecase = true
    opt.smartcase = true
    opt.updatetime = 350
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
    opt.compatible = false
    opt.wrap = true -- wrap long lines
    opt.linebreak = true
    opt.breakindent = true
    opt.showbreak = "  󱞩"
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
    opt.foldtext = ""
    opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client and client:supports_method("textDocument/foldingRange") then
                local win = vim.api.nvim_get_current_win()
                vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                vim.wo[win][0].foldtext = "v:lua.vim.lsp.foldtext()"
            end
        end,
    })
    opt.grepprg = "rg --vimgrep --no-heading --smart-case"
    opt.grepformat:append("%f:%l:%c:%m")
end, 1)
