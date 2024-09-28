return {
    "max397574/ki-bind.nvim",
    lazy = false,
    dependencies = { "nvimtools/hydra.nvim" },
    config = function()
        require("ki-bind").setup()
    end,
}
