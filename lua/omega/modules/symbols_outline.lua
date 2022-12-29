local symbols_outline = {
    "simrat39/symbols-outline.nvim",
    cmd = {
        "SymbolsOutline",
        "SymbolsOutlineOpen",
    },
    enabled = false,
}

symbols_outline.config = function()
    require("symbols-outline").setup()

    vim.api.nvim_set_hl(
        0,
        "FocusedSymbol",
        { italic = true, fg = require("omega.colors").get()["cyan"] }
    )
end

return symbols_outline
