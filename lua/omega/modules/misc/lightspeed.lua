---@type OmegaModule
local lightspeed = {}

lightspeed.configs = {
    ["lightspeed.nvim"] = function()
        require("lightspeed").setup({
            substitute_chars = { ["\r"] = "¬", [" "] = "␣" },
        })
        vim.keymap.set("n", "s", "<plug>Lightspeed_s")
        vim.keymap.set("n", "S", "<plug>Lightspeed_S")
        vim.keymap.set("n", "f", "<plug>Lightspeed_f")
        vim.keymap.set("n", "F", "<plug>Lightspeed_F")
    end,
}

return lightspeed
