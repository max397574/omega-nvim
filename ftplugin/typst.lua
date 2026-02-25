vim.bo.shiftwidth = 2
vim.bo.textwidth = 85

local ok, tpyst_preview = pcall(require, "typst-preview")
if ok then
    vim.keymap.set("n", "<localleader>j", function()
        require("typst-preview").next_page()
    end, { desc = "Next page" })

    vim.keymap.set("n", "<localleader>k", function()
        require("typst-preview").prev_page()
    end, { desc = "Previous page" })

    vim.keymap.set("n", "<localleader>r", function()
        require("typst-preview").refresh()
    end, { desc = "Refresh preview" })
end
