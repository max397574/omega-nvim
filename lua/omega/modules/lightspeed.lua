local lightspeed = {
    "ggandor/lightspeed.nvim",
}

lightspeed.init = function()
    vim.g.lightspeed_no_default_keymaps = true
    vim.keymap.set("n", "s", function()
        require("lightspeed").sx:go({})
    end)
    vim.keymap.set("n", "S", function()
        require("lightspeed").sx:go({ ["reverse?"] = true })
    end, {})
    vim.keymap.set("n", "f", function()
        require("lightspeed").ft:go({})
    end, {})
    vim.keymap.set("n", "F", function()
        require("lightspeed").ft:go({ ["reverse?"] = true })
    end, {})
end

lightspeed.config = function()
    require("lightspeed").setup({
        substitute_chars = { ["\r"] = "¬", [" "] = "␣" },
    })
    vim.keymap.set("n", "s", "<Plug>Lightspeed_s")
    vim.keymap.set("n", "S", "<Plug>Lightspeed_S")
    vim.keymap.set("n", "f", "<Plug>Lightspeed_f")
    vim.keymap.set("n", "F", "<Plug>Lightspeed_F")
    -- vim.keymap.set({ "n", "v", "x", "s" }, "t", "t")
end

return lightspeed
