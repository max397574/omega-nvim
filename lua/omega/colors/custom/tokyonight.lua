local colors = require("omega.colors").get()
return {
    ["@variable"] = { fg = colors.red },
    ["@function.builtin"] = { fg = colors.cyan },
    ["@parameter"] = { fg = colors.white },
}
