local colortils = {
    dir = "~/neovim_plugins/colortils.nvim/",
    cmd = "Colortils",
}

colortils.config = function()
    require("colortils").setup({
        border = require("omega.utils").border(),
        background = "#1e222a",
        picker = {
            display_gradients = true,
        },
    })
end

return colortils
