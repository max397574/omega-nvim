---@type OmegaModule
local undotree = {}

undotree.keybindings = function()
    require("which-key").register(
        { u = { "<cmd>UndotreeToggle<CR>", " UndoTree" } },
        { prefix = "<leader>", mode = "n" }
    )
end
return undotree
