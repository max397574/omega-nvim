---@type OmegaModule
local todo = {}

todo.plugins = {
    ["todo-comments.nvim"] = {
        "folke/todo-comments.nvim",
        cmd = { "TodoTrouble", "TodoTelescope", "TodoQuickFix", "TodoLocList" },
    },
}

todo.configs = {
    ["todo-comments.nvim"] = function()
        vim.cmd.PackerLoad({ "telescope.nvim", "trouble.nvim" })
        require("todo-comments").setup()
    end,
}

return todo
