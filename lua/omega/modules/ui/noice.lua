---@type OmegaModule
local noice = {}

noice.configs = {
    ["noice.nvim"] = function()
        vim.o.lazyredraw = false
        local config = {
            cmdline = {
                enabled = true,
                ---@type table<string, CmdlineFormat>
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
                    },
                },
                view = "cmdline",
            },
            popupmenu = {
                enabled = true,
                ---@type 'nui'|'cmp'
                backend = "nui",
            },
            notiy = {
                enabled = true,
            },
            messages = {
                enabled = true,
            },
            lsp = {
                hover = {
                    enabled = true,
                },
                progress = {
                    enabled = false,
                },
                signature = {
                    enabled = true,
                },
                message = {
                    enabled = true,
                },
                override = {
                    -- override the default lsp markdown formatter with Noice
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    -- override the lsp markdown formatter with Noice
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            routes = {
                {
                    view = "notify",
                    filter = { event = "msg_showmode" },
                },
                {
                    view = "notify",
                    filter = { find = "overly long" },
                    opts = { skip = true },
                },
                {
                    filter = {
                        event = "msg_show",
                        kind = "",
                        find = "written",
                    },
                    opts = { skip = true },
                },
            },
        }
        if vim.tbl_contains({ "bottom", "top" }, config.noice_cmdline_position) then
            config.cmdline.view = nil
            config.views = {
                cmdline_popup = {
                    position = {
                        row = vim.o.lines - 3,
                        col = "50%",
                    },
                    size = {
                        width = math.floor(vim.o.columns * 0.9),
                        height = "auto",
                    },
                    win_options = {
                        conceallevel = 0,
                    },
                },
                popupmenu = {
                    position = {
                        row = vim.o.lines - 16,
                        col = "50%",
                    },
                    size = {
                        width = math.floor(vim.o.columns * 0.9),
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
            }
            if require("omega.config").values.noice_cmdline_position == "top" then
                config.views.cmdline_popup.position.row = 2
                config.views.popupmenu.position.row = 5
            end
        end
        require("noice").setup(config)
    end,
}

return noice
