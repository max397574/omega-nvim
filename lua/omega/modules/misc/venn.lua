---@type OmegaModule
local venn = {}

venn.plugins = {
    ["venn.nvim"] = {
        "jbyuki/venn.nvim",
        cmd = { "VBox", "VBoxH", "VBoxD", "VBoxHO", "VBoxDO" },
    },
}

return venn
