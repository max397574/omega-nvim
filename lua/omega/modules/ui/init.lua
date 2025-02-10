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
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {},
    },
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd([[colorscheme tokyonight-storm]])
    --     end,
    -- },
    {
        "rcarriga/nvim-notify",
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = function(...)
                require("notify")(...)
            end
        end,
    },
    { "nvim-tree/nvim-web-devicons" },
    require("omega.modules.ui.heirline"),
}
