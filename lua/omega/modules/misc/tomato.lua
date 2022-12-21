local tomato = {}

tomato.configs = {
    ["tomato.nvim"] = function()
        require("tomato").setup()
    end,
}

return tomato
