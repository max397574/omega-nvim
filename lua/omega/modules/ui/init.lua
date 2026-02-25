---@diagnostic disable: missing-fields
return {
    {
        "max397574/omega-themes",
        lazy = false,
        priority = 100,
        config = function()
            local colorscheme_path = vim.fn.stdpath("cache") .. "/omega/highlights"
            if not vim.loop.fs_stat(colorscheme_path) then
                require("omega.colors").compile_theme(require("omega.config").colorscheme)
            end
            loadfile(colorscheme_path)()
        end,
    },
    {
        "chrisgrieser/nvim-origami",
        event = "VeryLazy",
        opts = {
            autoFold = {
                enabled = false,
                kinds = { "comment", "imports" }, ---@type lsp.FoldingRangeKind[]
            },
            foldKeymaps = {
                setup = false, -- modifies `h` and `l`
                hOnlyOpensOnFirstColumn = false,
            },
        },
        init = function()
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end,
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {},
    },
    {
        "rcarriga/nvim-notify",
        init = function()
            local overwrites = {
                ["Failed to discover workspace."] = function() end,
                ["No project root found"] = "Starting RA in standalone mode",
                ["# Config Change Detected. Reloading..."] = "Reloading Config",
            }
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = function(msg, ...)
                for k, v in pairs(overwrites) do
                    if string.find(msg, k) then
                        if type(v) == "string" then
                            require("notify")(v, ...)
                        else
                            v()
                        end
                        return
                    end
                end
                require("notify")(msg, ...)
            end
        end,
    },
    { "nvim-tree/nvim-web-devicons" },
    require("omega.modules.ui.heirline"),
}
