---@diagnostic disable: assign-type-mismatch
require("lazy").setup("omega.modules", {
    defaults = {
        lazy = true,
    },
    dev = {
        path = "~/neovim_plugins",
        patterns = { "max397574" },
    },
    ui = {
        icons = {
            lazy = "鈴",
        },
    },
    diff = {
        cmd = "git",
    },
    performance = {
        rtp = {
            paths = {
                vim.fn.expand("~") .. "/.config/nvim",
            },
            disabled_plugins = {
                "loaded_python3_provider",
                "python_provider",
                "node_provider",
                "ruby_provider",
                "perl_provider",
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "tar",
                "tarPlugin",
                "rrhelper",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "logiPat",
                "netrwSettings",
                "netrwFileHandlers",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
                "load_ftplugin",
                "indent_on",
                "netrwPlugin",
                "tohtml",
                "man",
            },
        },
    },
    change_detection = {
        enabled = false,
    },
})
