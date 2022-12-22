---@type OmegaModule
local todo = {}

todo.configs = {
    ["todo-comments.nvim"] = function()
        require("lazy").load({ plugins = { "telescope.nvim" } })
        require("lazy").load({ plugins = { "trouble.nvim" } })
        require("todo-comments").setup()
    end,
}

return todo
