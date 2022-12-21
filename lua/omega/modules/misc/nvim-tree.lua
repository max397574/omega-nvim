---@type OmegaModule
local nvim_tree = {}

nvim_tree.configs = {
    ["nvim-tree.lua"] = function()
        vim.api.nvim_create_autocmd("BufEnter", {
            nested = true,
            callback = function()
                if
                    #vim.api.nvim_list_wins() == 1
                    and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil
                then
                    vim.cmd.quit()
                end
            end,
        })
        require("nvim-tree").setup({
            filters = {
                dotfiles = true,
                exclude = {},
            },
            -- disable_netrw = true,
            -- hijack_netrw = true,
            ignore_ft_on_setup = { "alpha" },
            open_on_tab = false,
            hijack_cursor = true,
            hijack_unnamed_buffer_when_opening = false,
            -- update_cwd = true,
            update_focused_file = {
                enable = false,
                update_cwd = false,
            },
            view = {
                side = "left",
                width = 25,
                hide_root_folder = true,
            },
            git = {
                enable = true,
                ignore = true,
            },
            actions = {
                open_file = {
                    resize_window = true,
                },
            },
            renderer = {
                icons = {
                    show = {
                        git = false,
                    },
                },
                indent_markers = {
                    enable = false,
                },
            },
        })
    end,
}

return nvim_tree
