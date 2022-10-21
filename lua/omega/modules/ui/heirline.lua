local heirline_mod = {}

heirline_mod.plugins = {
    ["heirline.nvim"] = {
        "rebelot/heirline.nvim",
    },
    ["nvim-navic"] = {
        "SmiteshP/nvim-navic",
        ft = {
            "python",
            "html",
            "typescript",
            "zig",
            "css",
            "nix",
            "rust",
            "haskell",
            "tex",
            "vim",
            "lua",
        },
    },
}

heirline_mod.configs = {
    ["nvim-navic"] = function()
        require("nvim-navic").setup({ depth_limit = 4 })
    end,
    ["heirline.nvim"] = function()
        local theme = require("omega.colors.base16").themes(vim.g.colors_name)
        local conditions = require("heirline.conditions")
        local colors = require("omega.colors").get()
        local use_dev_icons = false
        local file_icons = {
            typescript = " ",
            json = " ",
            jsonc = " ",
            tex = "ﭨ ",
            ts = " ",
            python = " ",
            py = " ",
            java = " ",
            html = " ",
            css = " ",
            scss = " ",
            javascript = " ",
            js = " ",
            javascriptreact = " ",
            markdown = " ",
            md = " ",
            sh = " ",
            zsh = " ",
            vim = " ",
            rust = " ",
            rs = " ",
            cpp = " ",
            c = " ",
            go = " ",
            lua = " ",
            conf = " ",
            haskel = " ",
            hs = " ",
            ruby = " ",
            norg = " ",
            txt = " ",
        }
        local kind_hl = {
            Class = theme.base08,
            Color = theme.base08,
            Constant = theme.base09,
            Constructor = theme.base08,
            Enum = theme.base08,
            EnumMember = theme.base08,
            Event = theme.base0D,
            Field = theme.base08,
            File = theme.base09,
            Folder = theme.base09,
            Number = theme.base09,
            Boolean = theme.base09,
            Function = theme.base0D,
            Package = theme.base0D,
            Interface = theme.base0D,
            Keyword = theme.base0E,
            Method = theme.base08,
            Module = theme.base08,
            Operator = theme.base08,
            Property = theme.base0A,
            Reference = theme.base08,
            Snippet = theme.base0C,
            Struct = theme.base08,
            Text = theme.base0B,
            TypeParameter = theme.base08,
            Type = theme.base0A,
            Unit = theme.base08,
            Value = theme.base08,
            Variable = theme.base0E,
            Structure = theme.base0E,
            Identifier = theme.base08,
            Namespace = theme.base08,
            String = theme.base0B,
            Array = theme.base0B,
            Object = theme.base0A,
            Key = theme.base0E,
            Null = colors.grey_fg,
        }

        local color_utils = require("omega.utils.colors")
        vim.api.nvim_create_autocmd("User", {
            pattern = "HeirlineInitWinbar",
            callback = function(args)
                local buf = args.buf
                if
                    vim.tbl_contains({
                        "terminal",
                        "prompt",
                        "nofile",
                        "help",
                        "quickfix",
                    }, vim.bo[buf].buftype)
                    or vim.tbl_contains({
                        "gitcommit",
                        "fugitive",
                        "toggleterm",
                        "NvimTree",
                    }, vim.bo[buf].filetype)
                    or not vim.bo[buf].buflisted
                then
                    vim.opt_local.winbar = nil
                end
            end,
        })

        local Navic = {
            condition = function()
                if
                    not conditions.buffer_matches({
                        filetype = {
                            "python",
                            "html",
                            "typescript",
                            "zig",
                            "css",
                            "nix",
                            "rust",
                            "haskell",
                            "tex",
                            "vim",
                            "lua",
                        },
                    })
                then
                    return false
                end

                return require("nvim-navic").is_available()
            end,
            init = function(self)
                local data = require("nvim-navic").get_data() or {}
                local children = {}
                -- create a child for each level
                for i, d in ipairs(data) do
                    local child = {
                        {
                            provider = d.icon,
                            hl = function()
                                return conditions.is_active()
                                        and { fg = kind_hl[d.type], bg = colors.grey }
                                    or {
                                        fg = color_utils.blend_colors(
                                            kind_hl[d.type],
                                            colors.black,
                                            0.3
                                        ),
                                        bg = color_utils.blend_colors(
                                            colors.grey,
                                            colors.black,
                                            0.3
                                        ),
                                    }
                            end,
                        },
                        {
                            provider = function()
                                if d.name == "<Anonymous>" then
                                    return ""
                                end
                                return d.name
                            end,
                        },
                    }
                    -- add a separator only if needed
                    if #data > 1 and i < #data then
                        table.insert(child, {
                            provider = " ",
                            hl = function()
                                return conditions.is_active()
                                        and { fg = colors.green, bg = colors.grey }
                                    or {
                                        fg = color_utils.blend_colors(
                                            colors.green,
                                            colors.black,
                                            0.3
                                        ),
                                        bg = color_utils.blend_colors(
                                            colors.grey,
                                            colors.black,
                                            0.3
                                        ),
                                    }
                            end,
                        })
                    end
                    table.insert(children, child)
                end
                -- hack because depth_limit doesn't work correctly
                if #children > 4 then
                    local new_children = { { provider = ".. " } }
                    table.insert(new_children, children[#children - 3])
                    table.insert(new_children, children[#children - 2])
                    table.insert(new_children, children[#children - 1])
                    table.insert(new_children, children[#children])
                    self[1] = self:new(new_children, 1)
                else
                    -- instantiate the new child
                    self[1] = self:new(children, 1)
                end
            end,
            hl = function()
                return conditions.is_active() and { fg = colors.green, bg = colors.grey }
                    or {
                        fg = color_utils.blend_colors(colors.green, colors.black, 0.3),
                        bg = color_utils.blend_colors(colors.grey, colors.black, 0.3),
                    }
            end,
        }
        local winbar_line = {
            init = function(self)
                self.filename = vim.api.nvim_buf_get_name(0)
                self.mode = vim.fn.mode(1)
                local filename = self.filename
                local extension = vim.fn.fnamemodify(filename, ":e")
                if use_dev_icons then
                    self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(
                        filename,
                        extension,
                        { default = true }
                    )
                else
                    self.icon = file_icons[extension] or ""
                end
            end,
            condition = function()
                if vim.api.nvim_buf_get_name == "" then
                    return false
                end

                if vim.api.nvim_eval_statusline("%f", {})["str"] == "[No Name]" then
                    return false
                end
                return true
            end,
            {
                provider = function()
                    return ""
                end,
                hl = function()
                    return conditions.is_active() and { fg = colors.grey }
                        or {
                            fg = color_utils.blend_colors(colors.grey, colors.black, 0.3),
                        }
                end,
            },
            {
                provider = function(self)
                    return self.icon
                end,
                hl = function(self)
                    if use_dev_icons then
                        return { fg = self.icon_color }
                    else
                        return conditions.is_active() and { fg = colors.green, bg = colors.grey }
                            or {
                                fg = color_utils.blend_colors(colors.green, colors.black, 0.3),
                                bg = color_utils.blend_colors(colors.grey, colors.black, 0.3),
                            }
                    end
                end,
            },
            {
                init = function(self)
                    self.filename = vim.api.nvim_buf_get_name(0)
                    self.mode = vim.fn.mode(1)
                end,
                provider = function(self)
                    local filename = vim.fn.pathshorten(vim.fn.fnamemodify(self.filename, ":."))
                    if filename == "" then
                        return ""
                    end
                    return filename .. " "
                end,
                hl = function()
                    return conditions.is_active() and { fg = colors.green, bg = colors.grey }
                        or {
                            fg = color_utils.blend_colors(colors.green, colors.black, 0.3),
                            bg = color_utils.blend_colors(colors.grey, colors.black, 0.3),
                        }
                end,
            },
            Navic,
            {
                condition = function()
                    return not vim.bo.modified
                end,
                provider = " ",
                hl = function()
                    return conditions.is_active() and { fg = colors.red, bg = colors.grey }
                        or {
                            fg = color_utils.blend_colors(colors.red, colors.black, 0.3),
                            bg = color_utils.blend_colors(colors.grey, colors.black, 0.3),
                        }
                end,
                on_click = {
                    callback = function(_, winid)
                        vim.api.nvim_win_close(winid, true)
                    end,
                    name = function(self)
                        return "heirline_close_button_" .. self.winnr
                    end,
                },
            },
            {
                provider = function()
                    return ""
                end,
                hl = function()
                    return conditions.is_active() and { fg = colors.grey }
                        or {
                            fg = color_utils.blend_colors(colors.grey, colors.black, 0.3),
                        }
                end,
            },
        }

        if omega.config.statusline == "round_colored_bg" then
            require("heirline").setup(
                require("omega.modules.ui.heirline.round_colored_bg"),
                winbar_line
            )
        elseif omega.config.statusline == "round_dark_bg" then
            require("heirline").setup(
                require("omega.modules.ui.heirline.round_dark_bg"),
                winbar_line
            )
        elseif omega.config.statusline == "round_blended" then
            require("heirline").setup(
                require("omega.modules.ui.heirline.round_blended"),
                winbar_line
            )
        end
    end,
}

return heirline_mod
