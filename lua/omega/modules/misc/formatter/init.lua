local formatter = {}

formatter.plugins = {
    ["formatter.nvim"] = {
        "mhartington/formatter.nvim",
        cmd = { "FormatWrite", "Format", "FormatLock" },
        config = function()
            require("omega.modules.misc.formatter.configs")["formatter.nvim"]()
        end,
    },
}

return formatter
