---@type OmegaModule
local harpoon = {}

harpoon.plugins = {
    ["harpoon"] = {
        "ThePrimeagen/harpoon",
        keys = { "<leader>H" },
    },
}

harpoon.configs = {
    ["harpoon"] = function()
        require("telescope").load_extension("harpoon")
    end,
}

return harpoon
