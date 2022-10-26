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
                        lang = "regex",
                        view = "cmdline",
                    },
                    inspect = {
                        conceal = true,
                        icon = " ",
                        lang = "lua",
                        pattern = "^:%s*lua =%s*",
                        -- icon=" "
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
            lsp = {
                hover = {
                    enabled = false,
                },
                progress = {
                    enabled = false,
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row = -3,
                        col = "50%",
                    },
                    size = {
                        width = math.floor(vim.o.columns * 0.9),
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
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = true },
                },
            },
        })
    end,
}

return noice
