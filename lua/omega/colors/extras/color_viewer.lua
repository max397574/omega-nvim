local color_viewer = {}

local function get_colors()
    local colors = require("omega.colors").get()
    local theme = require("omega.colors.base16").themes(vim.g.colors_name)
    for name, color in pairs(theme) do
        colors[name] = color
    end
    return colors
end

function color_viewer.view_colors()
    require("plenary.reload").reload_module("omega.colors")
    local ns = vim.api.nvim_create_namespace("color_viewer")
    local lines = { " Colors", "" }
    local colors = get_colors()
    for name, color in pairs(colors) do
        table.insert(lines, "  " .. name .. ": " .. color)
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "q",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true }
    )
    vim.api.nvim_buf_set_keymap(
        buf,
        "n",
        "<ESC>",
        "<cmd>q<CR>",
        { noremap = true, silent = true, nowait = true }
    )
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "win",
        win = 0,
        width = 25,
        height = 33,
        col = 5,
        row = 0,
        border = "single",
        style = "minimal",
    })
    vim.api.nvim_win_set_option(win, "winblend", 0)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_add_highlight(buf, ns, "Special", 0, 0, -1)
    require("lazy").load("nvim-colorizer.lua")
    vim.cmd([[ColorizerAttachToBuffer]])
end

return color_viewer
