local holo = {}

holo.plugins = {
    ["hologram.nvim"] = {
        "edluffy/hologram.nvim",
        module = "hologram",
    },
}

holo.configs = {
    ["hologram.nvim"] = function()
        require("hologram").setup()
    end,
}

return holo
