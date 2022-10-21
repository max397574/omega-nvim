local bufferline_mod = {}

bufferline_mod.plugins = {
    ["bufferline.nvim"] = {
        "akinsho/bufferline.nvim",
        opt = true,
        setup = function()
            vim.api.nvim_create_autocmd({ "BufAdd", "TabEnter" }, {
                pattern = "*",
                group = vim.api.nvim_create_augroup("BufferLineLazyLoading", {}),
                callback = function()
                    local count = #vim.fn.getbufinfo({ buflisted = 1 })
                    if count >= 2 then
                        vim.cmd.PackerLoad("bufferline.nvim")
                    end
                end,
            })
        end,
    },
}

bufferline_mod.configs = {
    ["bufferline.nvim"] = function()
        local colors = require("omega.colors").get()
        local groups = require("bufferline.groups")

        if not vim.g.defined_buf_line_functions then
            vim.g.toggle_icon = " "
            vim.g.defined_buf_line_functions = true
            vim.cmd([=[
                function! Switch_theme(a,b,c,d)
                lua require"ignis.modules.files.telescope".colorschemes()
                endfunction
                function! Close_buf(a,b,c,d)
                    lua vim.cmd([[wq]])
                endfunction
                function! Toggle_light(a,b,c,d)
                    lua require"omega.colors".toggle_light()
                endfunction
            ]=])
        end

        require("bufferline").setup({
            highlights = {
                background = {
                    fg = colors.grey_fg,
                    bg = colors.black2,
                },

                -- buffers
                buffer_selected = {
                    fg = colors.white,
                    bg = colors.grey_fg,
                    bold = true,
                    italic = true,
                },

                duplicate_selected = {
                    fg = colors.white,
                    bg = colors.grey_fg,
                    bold = true,
                    italic = true,
                },
                duplicate_visible = {
                    fg = colors.white,
                    bg = colors.black2,
                    bold = true,
                    italic = true,
                },
                buffer_visible = {
                    fg = colors.white,
                    bg = colors.black2,
                },

                buffer = {
                    fg = colors.white,
                    bg = colors.black2,
                },

                error = {
                    fg = colors.light_grey,
                    bg = colors.black2,
                },
                error_diagnostic = {
                    fg = colors.light_grey,
                    bg = colors.black2,
                },

                close_button = {
                    fg = colors.light_grey,
                    bg = colors.black2,
                },
                close_button_visible = {
                    fg = colors.light_grey,
                    bg = colors.black2,
                },
                close_button_selected = {
                    fg = colors.red,
                    bg = colors.grey_fg,
                },
                fill = {
                    fg = colors.grey_fg,
                    bg = colors.darker_black,
                },
                indicator_selected = {
                    fg = colors.black2,
                    bg = colors.black,
                },

                modified = {
                    fg = colors.red,
                    bg = colors.black2,
                },
                modified_visible = {
                    fg = colors.red,
                    bg = colors.black2,
                },
                modified_selected = {
                    fg = colors.green,
                    bg = colors.grey_fg,
                },

                separator = {
                    fg = colors.darker_black,
                    bg = colors.black2,
                },
                separator_visible = {
                    fg = colors.darker_black,
                    bg = colors.black2,
                },
                separator_selected = {
                    fg = colors.darker_black,
                    bg = colors.grey_fg,
                },

                tab = {
                    fg = colors.light_grey,
                    bg = colors.one_bg3,
                },
                duplicate = {
                    fg = colors.light_grey,
                    bg = colors.black2,
                },
                tab_selected = {
                    fg = colors.black2,
                    bg = colors.nord_blue,
                },
                tab_close = {
                    fg = colors.red,
                    bg = colors.darker_black,
                },
            },
            options = {
                offsets = {
                    {
                        filetype = "NvimTree",
                        padding = 1,
                        highlight = "NvimTreeNormal",
                        text_align = "left",
                    },
                },
                close_icon = "",
                show_close_icon = false,
                separator_style = "slant",
                mode = "buffers",
                diagnostics = "nvim_diagnostic",
                always_show_bufferline = false,
                custom_areas = {
                    right = function()
                        local result = {}
                        table.insert(result, {
                            text = "%@Toggle_light@ " .. vim.g.toggle_icon .. "%X ",
                            fg = colors.white,
                            bg = colors.grey,
                        })

                        table.insert(result, {
                            text = "%@Close_buf@ X %X",
                            bg = colors.red,
                            fg = colors.black,
                        })
                        return result
                    end,
                },
                groups = {
                    options = {
                        toggle_hidden_on_enter = true,
                    },
                    items = {
                        groups.builtin.ungrouped,
                        {
                            highlight = { sp = colors.pink, underline = true },
                            name = "tests",
                            icon = "",
                            matcher = function(buf)
                                return buf.filename:match("_spec") or buf.filename:match("test")
                            end,
                        },
                        {
                            highlight = {
                                sp = colors.cyan,
                                underline = true,
                            },
                            name = "docs",
                            matcher = function(buf)
                                for _, ext in ipairs({ "md", "txt", "org", "norg", "wiki" }) do
                                    if ext == vim.fn.fnamemodify(buf.path, ":e") then
                                        return true
                                    end
                                end
                            end,
                        },
                    },
                },
            },
        })
    end,
}

bufferline_mod.keybindings = function()
    local wk = require("which-key")
    wk.register({
        b = {
            name = "﩯Buffer",
            ["b"] = { "<cmd>e #<CR>", "Switch to Other Buffer" },
            ["p"] = { "<cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
            ["["] = { "<cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
            ["n"] = { "<cmd>BufferLineCycleNext<CR>", "Next Buffer" },
            ["]"] = { "<cmd>BufferLineCycleNext<CR>", "Next Buffer" },
            ["d"] = {
                function()
                    vim.cmd.bdelete(vim.fn.bufnr("%"))
                end,
                "Delete Buffer",
            },
            ["g"] = { "<cmd>BufferLinePick<CR>", "Goto Buffer" },
        },
    }, {
        prefix = "<leader>",
        mode = "n",
    })
end

return bufferline_mod
