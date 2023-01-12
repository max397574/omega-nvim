local conditions = require("heirline.conditions")
local utilities = require("heirline.utils")
local utils = require("heirline.utils")
local colors = require("omega.colors").get()
local color_utils = require("omega.utils.colors")
local data = require("omega.modules.ui.heirline.data")

local priorities = {
    current_path = 60,
    workdir = 45,
    git_diff = 35,
    lsp = 10,
}

local space = setmetatable({ provider = " " }, {
    __call = function(_, n)
        return { provider = string.rep(" ", n) }
    end,
})

local align = { provider = "%=" }
local empty = { provider = "" }

local function word_counter()
    local wc = vim.fn.wordcount()
    if wc["visual_words"] then
        return wc["visual_words"]
    else
        return wc["words"]
    end
end

local file_icons = data.file_icons

local mode_icons = data.mode_icons

local mode_colors = {
    n = colors.red,
    i = colors.green,
    v = colors.purple,
    V = colors.purple,
    ["^V"] = colors.blue,
    c = colors.red,
    s = colors.yellow,
    S = colors.yellow,
    ["^S"] = colors.yellow,
    R = colors.purple,
    r = colors.purple,
    ["!"] = colors.purple,
    t = colors.purple,
}

local background_color = colors.one_bg

local mode_icon = {
    hl = function(self)
        local mode = self.mode:sub(1, 1)
        return {
            bg = color_utils.blend_colors(mode_colors[mode] or colors.blue, background_color, 0.15),
            fg = mode_colors[mode] or colors.blue,
        }
    end,
    provider = function(self)
        return "%2(" .. mode_icons[self.mode:sub(1, 1)] .. "%)"
    end,
}

local vim_mode = {
    init = function(self)
        self.mode = vim.fn.mode(1)
    end,
    condition = function()
        return vim.bo.buftype == ""
    end,
    {
        mode_icon,
        {
            provider = "",
            hl = function(self)
                local mode = self.mode:sub(1, 1)
                return {
                    fg = color_utils.blend_colors(
                        mode_colors[mode] or colors.blue,
                        background_color,
                        0.15
                    ),
                }
            end,
        },
    },
}
local work_dir_icon = {
    provider = " ",
    hl = function()
        return {
            fg = colors.green,
            bg = color_utils.blend_colors(colors.green, background_color, 0.15),
        }
    end,
}

local work_dir1 = {
    provider = "",
    hl = {
        fg = color_utils.blend_colors(colors.green, background_color, 0.15),
        bg = colors.black,
    },
}
local work_dir2 = {
    {
        provider = "",
        hl = {
            fg = color_utils.blend_colors(colors.green, background_color, 0.15),
            bg = background_color,
        },
    },
    {
        provider = " ",
        hl = {
            bg = background_color,
        },
    },
}
local work_dir3 = {
    provider = "",
    hl = {
        bg = colors.black,
        fg = background_color,
    },
}

local work_dir_name = {
    flexible = priorities.workdir,
    condition = function(self)
        if vim.bo.buftype == "" then
            return self.pwd
        end
    end,
    hl = {
        fg = colors.green,
        bg = background_color,
    },
    {
        work_dir1,
        work_dir_icon,
        work_dir2,
        {
            provider = function(self)
                return self.pwd
            end,
        },
        work_dir3,
        { provider = " ", hl = { bg = colors.black } },
    },
    {
        work_dir1,
        work_dir_icon,
        work_dir2,
        {
            provider = function(self)
                return vim.fn.pathshorten(self.pwd)
            end,
        },
        work_dir3,
        { provider = " ", hl = { bg = colors.black } },
    },
    empty,
}

local current_dir = {
    init = function(self)
        self.pwd = vim.fn.fnamemodify(vim.fn.getcwd(0), ":~")
    end,
    work_dir_name,
}

local help_file_name = {
    condition = function()
        return vim.bo.filetype == "help"
    end,
    provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = { fg = colors.dark_blue },
}

local file_icon = {
    provider = function(self)
        return self.icon and self.icon
    end,
    hl = function()
        return {
            fg = colors.blue,
            bg = color_utils.blend_colors(colors.blue, background_color, 0.15),
        }
    end,
}

local current_path = {
    condition = function(self)
        if vim.bo.buftype == "" then
            return self.current_path
        end
    end,
    hl = {
        fg = colors.blue,
        bg = background_color,
    },
    flexible = priorities.current_path,
    {
        provider = function(self)
            return self.current_path
        end,
    },
    {
        provider = function(self)
            return vim.fn.pathshorten(self.current_path, 2)
        end,
    },
    empty,
}

local file_name = {
    provider = function(self)
        return self.filename
    end,
    hl = { fg = colors.blue, bg = background_color },
}

local file_flags = {
    {
        provider = function()
            if vim.bo.modified then
                return "  "
            end
        end,
        hl = { fg = colors.blue, bg = background_color },
    },
    {
        provider = function()
            if not vim.bo.modifiable or vim.bo.readonly then
                return "  "
            end
        end,
        hl = { fg = colors.blue, bg = background_color },
    },
}

local file_name_block = {
    init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ":e")
        self.current_path = vim.fn.fnamemodify(vim.fn.fnamemodify(filename, ":.h"), ":h") .. "/"
        self.filename = vim.fn.fnamemodify(filename, ":t")
        self.icon = file_icons[extension] or ""
    end,
    hl = {
        bg = background_color,
    },
    on_click = {
        callback = function()
            print(vim.fn.expand("%"))
        end,
        name = "print_file_name",
    },
    condition = function()
        return not conditions.buffer_matches({
            buftype = { "nofile", "hidden" },
            filetype = { "NvimTree", "dashboard" },
        })
    end,

    {
        provider = "",
        hl = {
            fg = color_utils.blend_colors(colors.blue, background_color, 0.15),
            bg = colors.black,
        },
    },
    file_icon,
    {
        provider = "",
        hl = {
            fg = color_utils.blend_colors(colors.blue, background_color, 0.15),
            bg = background_color,
        },
    },
    {
        provider = " ",
        hl = {
            bg = background_color,
        },
    },
    current_path,
    file_name,
    file_flags,
    {
        provider = "",
        hl = {
            fg = background_color,
            bg = colors.black,
        },
    },
}

local git_branch = {
    condition = conditions.is_git_repo,
    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
    end,
    provider = function(self)
        return " " .. self.status_dict.head .. " "
    end,
    hl = { fg = colors.blue },
}

local git = {
    flexible = priorities.git_diff,
    condition = conditions.is_git_repo,
    on_click = {
        callback = function()
            vim.defer_fn(function()
                require("toggleterm.terminal").Terminal
                    :new({ cmd = "lazygit", close_on_exit = true })
                    :toggle()
            end, 10)
        end,
        name = "toggle_lazygit",
    },

    init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0
            or self.status_dict.removed ~= 0
            or self.status_dict.changed ~= 0
    end,

    hl = { fg = colors.orange },

    {
        {
            provider = function(self)
                local count = self.status_dict.added or 0
                return count > 0 and ("  " .. count)
            end,
            hl = { fg = colors.green },
        },
        {
            provider = function(self)
                local count = self.status_dict.removed or 0
                return count > 0 and ("  " .. count)
            end,
            hl = { fg = colors.red },
        },
        {
            provider = function(self)
                local count = self.status_dict.changed or 0
                return count > 0 and ("  " .. count)
            end,
            hl = { fg = colors.orange },
        },
    },
    empty,
}

local function progress_bar()
    local sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇" }
    local curr_line = vim.api.nvim_win_get_cursor(0)[1]
    local lines = vim.api.nvim_buf_line_count(0)
    local i = math.floor(curr_line / lines * (#sbar - 1)) + 1
    return sbar[i]
end

local round_progress = {
    {
        provider = "",
        hl = function(_)
            return {
                fg = color_utils.blend_colors(colors.purple, background_color, 0.15),
                bg = "none",
            }
        end,
    },
    {
        provider = "%3(%P%)",
        hl = {
            bg = color_utils.blend_colors(colors.purple, background_color, 0.15),
            fg = colors.purple,
        },
    },
    {
        provider = "",
        hl = function(_)
            return {
                fg = color_utils.blend_colors(colors.purple, background_color, 0.15),
                bg = background_color,
            }
        end,
    },
    {
        provider = function()
            return " " .. progress_bar() .. " "
        end,
        hl = function()
            return { bg = background_color, fg = colors.purple }
        end,
    },
    {
        provider = "",
        hl = function(_)
            return { fg = background_color, bg = "none" }
        end,
    },
}

local diagnostics = {

    condition = conditions.has_diagnostics,

    static = {
        error_icon = " ",
        warn_icon = " ",
        info_icon = " ",
        hint_icon = " ",
    },
    on_click = {
        callback = function()
            require("trouble").toggle({ mode = "document_diagnostics" })
        end,
        name = "heirline_diagnostics",
    },

    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,

    {
        provider = function(self)
            return self.errors > 0 and (self.error_icon .. self.errors .. " ")
        end,
        hl = { fg = utils.get_highlight("DiagnosticError").fg },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
        end,
        hl = { fg = utils.get_highlight("DiagnosticWarn").fg },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info_icon .. self.info .. " ")
        end,
        hl = { fg = utils.get_highlight("DiagnosticInfo").fg },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = utils.get_highlight("DiagnosticHint").fg },
    },
}

local lsp_progress = {
    flexible = priorities.lsp,
    condition = function()
        if not omega.lsp_active then
            return false
        end
        -- if #vim.lsp.get_active_clients() == 0 then
        --     return false
        -- end
        return true
    end,
    hl = { fg = colors.blue },
    {
        provider = function()
            local messages = vim.lsp.util.get_progress_messages()
            if #messages == 0 then
                return ""
            end
            local status = {}
            for _, msg in pairs(messages) do
                table.insert(status, msg.percentage or 0)
            end
            local spinners = {
                "⠋",
                "⠙",
                "⠹",
                "⠸",
                "⠼",
                "⠴",
                "⠦",
                "⠧",
                "⠇",
                "⠏",
            }
            local ms = vim.loop.hrtime() / 1000000
            local frame = math.floor(ms / 120) % #spinners
            return spinners[frame + 1] .. " " .. table.concat(status, " | ")
        end,
    },
    empty,
}

local coords = {
    {
        provider = "",
        hl = {
            fg = color_utils.blend_colors(colors.orange, background_color, 0.15),
        },
    },
    {
        provider = "  ",
        hl = {
            fg = colors.orange,
            bg = color_utils.blend_colors(colors.orange, background_color, 0.15),
        },
    },
    {
        provider = "",
        hl = {
            fg = color_utils.blend_colors(colors.orange, background_color, 0.15),
            bg = background_color,
        },
    },
    {
        provider = "%4(%l%):%2c",
        hl = { fg = colors.orange, bg = background_color },
    },
    {
        provider = "",
        hl = { fg = background_color },
    },
}
local word_count = {
    {
        init = function(self)
            self.mode = vim.fn.mode(1)
        end,
        provider = function()
            return string.rep(" ", 5 - #tostring(word_counter())) .. ""
        end,
        hl = function(self)
            local mode = self.mode:sub(1, 1)
            return {
                fg = color_utils.blend_colors(
                    mode_colors[mode] or colors.blue,
                    background_color,
                    0.15
                ),
            }
        end,
    },
    {
        init = function(self)
            self.mode = vim.fn.mode(1)
        end,
        provider = function()
            return word_counter()
        end,
        hl = function(self)
            local mode = self.mode:sub(1, 1)
            return {
                bg = color_utils.blend_colors(
                    mode_colors[mode] or colors.blue,
                    background_color,
                    0.15
                ),
                fg = mode_colors[mode] or colors.blue,
            }
        end,
        condition = conditions.is_active,
    },
    {
        init = function(self)
            self.mode = vim.fn.mode(1)
        end,
        provider = "█",
        hl = function(self)
            local mode = self.mode:sub(1, 1)
            return {
                fg = color_utils.blend_colors(
                    mode_colors[mode] or colors.blue,
                    background_color,
                    0.15
                ),
            }
        end,
    },
}

local inactive_statusline = {
    condition = function()
        local winid = vim.api.nvim_get_current_win()
        local curwin = tonumber(vim.g.actual_curwin)
        return winid ~= curwin
    end,
    current_dir,
    file_name_block,
    align,
}

local default_statusline = {
    vim_mode,
    condition = conditions.is_active,
    space,
    current_dir,
    file_name_block,
    space,
    git,
    space,
    lsp_progress,
    diagnostics,
    space,
    align,
    space,
    git_branch,
    space,
    { flexible = 30, coords },
    space,
    round_progress,
    space,
    { flexible = 5, word_count },
}

local help_file_line = {
    condition = function()
        return conditions.buffer_matches({
            buftype = { "help", "quickfix" },
        })
    end,
    {
        provider = function()
            return string.upper(vim.bo.filetype)
        end,
        hl = {
            fg = colors.green,
            italic = true,
        },
    },
    space,
    align,
    help_file_name,
    align,
    round_progress,
}

local startup_nvim_statusline = {
    condition = function()
        return conditions.buffer_matches({
            filetype = { "startup", "TelescopePrompt" },
        })
    end,
    align,
    provider = "",
    align,
}

return {
    fallthrough = false,

    startup_nvim_statusline,
    help_file_line,
    inactive_statusline,
    default_statusline,
}
