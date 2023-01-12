local add_cmd = vim.api.nvim_create_user_command

add_cmd("ReloadColors", function()
    require("colorscheme_switcher").new_scheme()
end, {
    desc = "Reload colors",
})

local function filetypes()
    return {
        "lua",
        "rust",
        "python",
        "c",
        "cpp",
        "java",
        "tex",
        "javascript",
        "typescrip",
        "plain",
        "norg",
    }
end

-- add_cmd("Tmp", function(args)
--     require("lazy").load({ plugins = { "nvim-lspconfig" } })
--     require("omega.extras").scratch_buf(args)
-- end, {
--     nargs = "?",
--     complete = filetypes,
--     desc = "Open scratch buffer",
-- })

add_cmd("CursorNodes", function()
    local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
    while node do
        vim.pretty_print(node:type())
        node = node:parent()
    end
end, {
    desc = "Print nodes under cursor",
})

local function ShowLangTree(langtree, indent)
    local ts = vim.treesitter
    langtree = langtree or ts.get_parser()
    indent = indent or ""

    print(indent .. langtree:lang())
    for _, region in pairs(langtree:included_regions()) do
        if type(region[1]) == "table" then
            print(indent .. "  " .. vim.inspect(region))
        else
            print(indent .. "  " .. vim.inspect({ region[1]:range() }))
        end
    end
    for lang, child in pairs(langtree._children) do
        ShowLangTree(child, indent .. "  ")
    end
end

add_cmd("LangTree", function()
    ShowLangTree()
end, {
    desc = "Shows language tree",
})

add_cmd("ClearUndo", function()
    local old = vim.opt.undolevels
    vim.opt.undolevels = -1
    vim.cmd.exe([["normal a \<BS>\<Esc>"]])
    vim.opt.undolevels = old
end, {
    desc = "Clear undo history",
})

add_cmd("CodeActions", function()
    local line_diagnostics = vim.lsp.diagnostic.get_line_diagnostics()
    local parameters = vim.lsp.util.make_range_params()
    parameters.context = { diagnostics = line_diagnostics }
    local all_responses = vim.lsp.buf_request_sync(0, "textDocument/codeAction", parameters)

    if all_responses == nil or vim.tbl_isempty(all_responses) then
        vim.api.nvim_notify("No code actions available", vim.log.levels.WARN, {})
        return
    end

    local all_code_actions = {}

    for _, client_response in ipairs(all_responses) do
        for _, code_action in ipairs(client_response.result) do
            table.insert(all_code_actions, code_action)
        end
    end
    vim.pretty_print(all_code_actions)
end, {
    desc = "Get Code Actions",
})

add_cmd("ViewColors", function()
    require("omega.colors.extras.color_viewer").view_colors()
end, {
    desc = "View colors",
})

local function colorschemes()
    vim.pretty_print(require("omega.utils").get_themes())
    -- return require("omega.utils").get_themes()
    return {
        "catppuccin_frappe",
        "catppuccin_macchiato",
        "doom_one",
        "everforest",
        "everforest_light",
        "gruvbuddy",
        "horizon",
        "lapce",
        "onedark",
        "tokyodark",
    }
end

add_cmd("Colorschemelocal", function(args)
    local old_theme = vim.g.colors_name
    require("omega.colors").init(args.args)
    local ns = vim.api.nvim_create_namespace("local_theme")
    local colors = vim.api.nvim__get_hl_defs(0)
    for k, v in pairs(colors) do
        pcall(vim.api.nvim_set_hl, ns, k, v)
    end
    require("omega.colors").init(old_theme)
    vim.api.nvim_win_set_hl_ns(0, ns)
end, {
    nargs = "?",
    complete = colorschemes,
})

add_cmd("Redir", function(args)
    local out = vim.fn.execute(args.args)
    vim.cmd.tabnew()
    vim.opt_local.buftype = "nofile"
    vim.opt_local.bufhidden = "wipe"
    vim.fn.setline(1, vim.fn.split(out, "\n"))
end, {
    nargs = "*",
})

add_cmd("CacheOmega", function() end, {})
