local symbols_outline = {}

symbols_outline.configs = {
    ["symbols-outline.nvim"] = function()
        require("symbols-outline").setup({ highlight_hovered_item = true })

        vim.api.nvim_set_hl(
            0,
            "FocusedSymbol",
            { italic = true, fg = require("omega.colors").get()["cyan"] }
        )
    end,
}

return symbols_outline
