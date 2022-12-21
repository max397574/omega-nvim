local sj = {}

sj.configs = {
    ["sj.nvim"] = function()
        require("sj").setup({
            -- automatically jump on a match if it is the only one
            auto_jump = true,
            -- help to better identify labels and matches
            use_overlay = true,
            highlights = {
                -- used for the labels
                SjLabel = { bold = false },
                -- used for everything that is not a match
                SjOverlay = { bold = false, italic = false },
                -- used to highlight matches
                SjSearch = { bold = false },
                -- used in the cmd line when the pattern has no matches
                SjWarning = { bold = false },
            },
        })
        -- vim.keymap.set("n", "/", function()
        --     require("sj").run()
        -- end, {})
    end,
}

return sj
