vim.defer_fn(function()
    require("impatient")
end, 0)
loadfile(vim.fn.stdpath("cache") .. "/omega/highlights")()

require("omega.core.settings")

require("omega.core")
