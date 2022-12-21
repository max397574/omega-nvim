---@type OmegaModule
local harpoon = {}

harpoon.configs = {
    ["harpoon"] = function()
        require("telescope").load_extension("harpoon")
    end,
}

return harpoon
