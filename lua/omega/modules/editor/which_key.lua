local which_key = {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        icons = {
            rules = {
                { pattern = "paste", icon = "", hl = "@string" },
                { pattern = "yank", icon = "", hl = "@label" },
                { pattern = "insert", icon = "", hl = "@string" },
                { pattern = "save", icon = "󰆓", hl = "@number" },
                { pattern = "buffer", icon = "", hl = "Structure" },
                { pattern = "tab", icon = "", color = "red" },
                { pattern = "lazy", icon = "󰏗", hl = "@number" },
                { pattern = "grep", icon = "", color = "red" },
                { pattern = "browser", icon = "", color = "red" },
                { pattern = "help", icon = "", color = "red" },
                { pattern = "buffers", icon = "", color = "red" },
                { pattern = "view", icon = "", color = "red" },
                { pattern = "error", icon = "", hl = "@number" },
                { pattern = "quickfix", icon = "", hl = "Structure" },
            },
        },
    },
}
function which_key.config(_, opts)
    require("which-key").setup(opts)
    local wk = require("which-key")
    wk.add({
        { "<leader>i", desc = "Insert" },
        { "<leader>b", desc = "Buffer" },
        { "<leader>t", desc = "Tab" },
        { "<leader>L", desc = "Lazy" },
        { "<leader>v", desc = "View" },
        { "<leader>x", desc = "Error" },
        { "<leader>q", desc = "Quickfix" },
    })
end

return which_key