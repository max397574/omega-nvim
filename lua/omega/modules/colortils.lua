local colortils = {
    "nvim-colortils/colortils.nvim",
    cmd = "Colortils",
}

colortils.config = function()
    require("colortils").setup({
        border = require("omega.utils").border(),
        background = "#1e222a",
    })
end

return colortils
