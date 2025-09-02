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
        end,
    })
end, {})

vim.api.nvim_create_user_command("TestCodeForces", function(args)
    if args.args == "reuse" then
        require("omega.utils").test_CF(true)
    else
        require("omega.utils").test_CF(false)
    end
end, {
    desc = "Test a Code Forces submission",
    nargs = "?",
    complete = function()
        return { "reuse" }
    end,
})
