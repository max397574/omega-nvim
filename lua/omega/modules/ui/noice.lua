---@type OmegaModule
local noice = {}

noice.plugins = {
    ["noice.nvim"] = {
        "folke/noice.nvim",
    },
    ["nvim-notify"] = {
        "rcarriga/nvim-notify",
        module = "notify",
    },
    ["nui.nvim"] = {
        "MunifTanjim/nui.nvim",
        module = { "nui" },
    },
}

noice.configs = {
    ["noice.nvim"] = function()
        vim.o.lazyredraw = false
        require("noice").setup({
            cmdline = {
                enabled = true,
                format = {
                    search_down = {
                        kind = "Search",
                        pattern = "^/",
                        ft = "regex",
                        view = "cmdline",
                    },
                },
            },
            popupmenu = {
                enabled = true,
            },
            notiy = {
                enabled = true,
            },
            messages = {
                enabled = true,
            },
            lsp_progress = {
                enabled = false,
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = 5,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = "auto",
                    },
                },
                popupmenu = {
                    relative = "editor",
                    position = {
                        row = 8,
                        col = "50%",
                    },
                    size = {
                        width = 60,
                        height = 10,
                    },
                    border = {
                        style = "rounded",
                        padding = { 0, 1 },
                    },
                    win_options = {
                        winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
                    },
                },
            },
        })
    end,
}

return noice
