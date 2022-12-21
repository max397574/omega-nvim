---@type OmegaModule
local todo = {}

todo.configs = {
    ["todo-comments.nvim"] = function()
        require("lazy").load("telescope.nvim")
        require("lazy").load("trouble.nvim")
        require("todo-comments").setup()
    end,
}

return todo
