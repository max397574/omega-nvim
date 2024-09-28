vim.api.nvim_create_user_command("NewTheme", function(args)
    require("omega.colors").new_theme(args.fargs[1])
end, {
    desc = "New theme",
    nargs = 1,
    complete = function(_, cmd_text)
        local themes = require("omega.utils").get_themes()
        local cmdline = vim.api.nvim_parse_cmd(cmd_text, {})
        if #cmdline.args == 0 then
            return themes
        elseif #cmdline.args == 1 then
            if not vim.tbl_contains(themes, cmdline.args[1]) then
                local completions = {}
                for _, theme in ipairs(themes) do
                    if vim.startswith(theme, cmdline.args[1]) then
                        table.insert(completions, theme)
                    end
                end
                return completions
            end
            return {}
        end
    end,
})

vim.api.nvim_create_user_command("ViewColors", function()
    require("omega.colors.extras.color_viewer").view_colors()
end, { desc = "View Colors", nargs = 0 })

vim.api.nvim_create_user_command("ViewHighlights", function()
    require("omega.colors.extras.highlight_viewer")()
end, { desc = "View Highlights", nargs = 0 })

vim.api.nvim_create_user_command("ViewNorgSpec", function()
    if vim.loop.fs_stat("./specs.norg") then
        vim.fn.delete("./specs.norg")
    end
    vim.fn.system({
        "curl",
        "https://raw.githubusercontent.com/nvim-neorg/norg-specs/main/1.0-specification.norg",
        "-o",
        "./specs.norg",
    })
    vim.cmd.e("./specs.norg")
    vim.keymap.set("n", "q", function()
        vim.cmd.bdelete()
        if vim.loop.fs_stat("./specs.norg") then
            vim.fn.delete("./specs.norg")
        end
    end, { buffer = true })
end, { desc = "View Norg Specification" })

vim.api.nvim_create_user_command("TypstWatch", function()
    local watch_job = vim.system({
        "typst",
        "watch",
        ---@diagnostic disable-next-line: assign-type-mismatch
        vim.fn.expand("%"),
    })
    vim.api.nvim_buf_create_user_command(0, "TypstStop", function()
        watch_job:kill(9)
        vim.api.nvim_buf_del_user_command(0, "TypstStop")
    end, {})

    vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
            watch_job:kill(9)
            vim.api.nvim_buf_del_user_command(0, "TypstStop")
        end,
    })
end, {})

vim.api.nvim_create_user_command("HideCursor", function()
    local highlights = { "LspReferenceText", "LspReferenceRead", "LspReferenceWrite" }
    local highlight_definitions = {}
    for _, highlight in ipairs(highlights) do
        highlight_definitions[highlight] = vim.api.nvim_get_hl(0, { name = highlight })
        vim.api.nvim_set_hl(0, highlight, {})
    end
    local old_cursor = vim.go.guicursor
    vim.api.nvim_set_hl(0, "HiddenCursor", { blend = 100, nocombine = true })
    vim.go.guicursor = "a:HiddenCursor"
    vim.o.relativenumber = false
    vim.o.cursorline = false
    vim.api.nvim_create_user_command("ShowCursor", function()
        vim.api.nvim_del_user_command("ShowCursor")
        for highlight, def in pairs(highlight_definitions) do
            vim.api.nvim_set_hl(0, highlight, def)
        end
        vim.go.guicursor = old_cursor
        vim.o.cursorline = true
        vim.o.relativenumber = true
    end, {})
end, {})
