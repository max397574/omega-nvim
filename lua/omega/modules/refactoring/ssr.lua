---@type OmegaModule
local ssr = {}

ssr.plugins = {
    ["ssr.nvim"] = {
        "cshuaimin/ssr.nvim",
        module = "ssr",
    },
}

ssr.keybindings = function()
    require("which-key").register({
        ["R"] = {
            name = " Refactoring",
            s = {
                function()
                    require("ssr").open()
                end,
                "Structural replace",
            },
        },
    }, { prefix = "<leader>", mode = "n" })
end

return ssr
