---@type OmegaModule
local gitsigns = {}

gitsigns.configs = {
    ["gitsigns.nvim"] = function()
        require("gitsigns").setup({
            -- current_line_blame = true,
            signs = {
                add = {
                    hl = "GitSignsAdd",
                    text = "▍",
                    numhl = "GitSignsAddNr",
                    linehl = "GitSignsAddLn",
                },
                change = {
                    hl = "GitSignsChange",
                    text = "▍",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
                delete = {
                    hl = "GitSignsDelete",
                    text = "▸",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "▾",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "▍",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
            },
        })
        vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#9ece6a" })
        vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#e0af68" })
        vim.api.nvim_set_hl(0, "GitSignsDelte", { fg = "#db4b4b" })
    end,
}

gitsigns.keybindings = function() end

return gitsigns
