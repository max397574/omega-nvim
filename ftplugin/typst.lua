vim.bo.shiftwidth = 2
vim.bo.textwidth = 85

-- local ok, typst_preview = pcall(require, "typst-preview")
local ok, preview = pcall(require, "omega.modules.lsp.typst_preview")
if ok then
    vim.api.nvim_create_augroup("TypstPreview", {})

    local function setup_preview()
        vim.cmd.TypstWatch()
        vim.api.nvim_create_autocmd("TextChangedI", {
            callback = function()
                if vim.api.nvim_win_get_cursor(0)[2] > 80 then
                    preview.clear_preview()
                end
            end,
            group = "TypstPreview",
        })
        vim.api.nvim_create_autocmd("InsertEnter", {
            callback = function()
                if vim.api.nvim_win_get_cursor(0)[2] > 80 then
                    preview.clear_preview()
                end
            end,
            group = "TypstPreview",
        })
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = "*.typ",
            callback = function()
                preview.render()
            end,
            group = "TypstPreview",
        })
        vim.api.nvim_create_autocmd("QuitPre", {
            pattern = "*.typ",
            callback = function()
                preview.clear_preview()
            end,
            group = "TypstPreview",
        })
    end

    vim.keymap.set("n", "<localleader>j", function()
        -- typst_preview.next_page()
        preview.next_page()
    end, { buf = 0 })

    vim.keymap.set("n", "<localleader>k", function()
        -- typst_preview.prev_page()
        preview.previous_page()
    end, { buf = 0 })

    vim.keymap.set("n", "<localleader>r", function()
        -- typst_preview.refresh()
        preview.render()
    end, { buf = 0 })
    vim.keymap.set("n", "<localLeader>p", function()
        setup_preview()
        preview.render()
    end, { buf = 0 })
end
