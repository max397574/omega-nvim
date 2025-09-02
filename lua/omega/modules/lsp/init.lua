-- some stuff taken from config from @lewis6991 on github

local function lsp_config()
    require("omega.modules.lsp.lua").setup()
    require("omega.modules.lsp.python").setup()
    require("omega.modules.lsp.ocaml").setup()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if not client then
                return
            end
            local bufnr = args.buf
            local disable_code_action = { "ruff", "tinymist" }

            -- print(client.name)
            if
                client.server_capabilities.codeActionProvider and not vim.tbl_contains(disable_code_action, client.name)
            then
                require("omega.modules.lsp.available_code_action").setup(bufnr, client)
            end
            if client.name == "tinymist" then
                -- vim.lsp.semantic_tokens.stop(bufnr, client.id)
                client.server_capabilities.semanticTokensProvider = nil
            end
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "grd", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "K", function()
                vim.lsp.buf.hover({ border = require("omega.utils").border(), title = "Help" })
            end, opts)

            vim.keymap.set("n", "gD", vim.lsp.buf.implementation, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "grc", vim.lsp.codelens.run, { desc = "lsp.codelens.run", buffer = bufnr })
        end,
        group = vim.api.nvim_create_augroup("lsp-on-attach", {}),
    })

    local function debounce(ms, fn)
        local timer = assert(vim.uv.new_timer())
        return function(...)
            local argc, argv = select("#", ...), { ... }
            timer:start(ms, 0, function()
                timer:stop()
                vim.schedule(function()
                    fn(unpack(argv, 1, argc))
                end)
            end)
        end
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        desc = "Lsp codelens",
        callback = function(args)
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            if client:supports_method("textDocument/codeLens") then
                vim.lsp.codelens.refresh({ bufnr = args.buf })
                vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter", "BufEnter", "CursorMoved" }, {
                    callback = debounce(200, function(args0)
                        vim.lsp.codelens.refresh({ bufnr = args0.buf })
                    end),
                })
                return true
            end
        end,
    })

    vim.api.nvim_create_autocmd({ "FocusGained", "WinEnter", "BufEnter", "CursorMoved" }, {
        desc = "Lsp: highlight references",
        callback = debounce(200, function(args)
            vim.lsp.buf.clear_references()
            local win = vim.api.nvim_get_current_win()
            local bufnr = args.buf --- @type integer
            local method = "textDocument/documentHighlight"
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, method = method })) do
                local enc = client.offset_encoding
                client:request(method, vim.lsp.util.make_position_params(0, enc), function(_, result, ctx)
                    if not result or win ~= vim.api.nvim_get_current_win() then
                        return
                    end
                    vim.lsp.util.buf_highlight_references(ctx.bufnr, result, enc)
                end, bufnr)
            end
        end),
    })

    vim.lsp.enable({
        "tailwindcss",
        "ts_ls",
        -- "ty",
        -- "ruff",
        "cssls",
    })

    vim.api.nvim_set_hl(0, "DiagnosticHeader", { link = "Special" })

    -- jump to the first definition automatically if two definitions are on same line (for luals `local x = function()`)
    vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx)
        print("hi")
        if not result or vim.tbl_isempty(result) then
            return
        end
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if not client then
            return
        end

        if vim.islist(result) then
            local results = vim.lsp.util.locations_to_items(result, client.offset_encoding)
            if #results == 1 or (#results == 2 and results[1].lnum == results[2].lnum) then
                vim.lsp.util.show_document(result[1], client.offset_encoding, { reuse_win = false, focus = true })
            else
                local title = "LSP locations"
                local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)

                vim.fn.setqflist({}, " ", { title = title, items = items })
                vim.cmd("botright copen")

                -- todo: default action
            end
        else
            vim.lsp.util.show_document(result, client.offset_encoding, { reuse_win = false, focus = true })
        end
    end
    local sign_icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        HINT = "",
    }
    local signs = { text = {}, numhl = {} }
    for severity, icon in pairs(sign_icons) do
        signs.text[vim.diagnostic.severity[severity]] = icon
        signs.numhl[vim.diagnostic.severity[severity]] = "Diagnostic" .. severity
    end

    vim.diagnostic.config({
        float = {
            focusable = true,
            ---@diagnostic disable-next-line: assign-type-mismatch
            border = require("omega.utils").border(),
            scope = "cursor",
            title = "Diagnostics",
            min_width = 12,
            header = "",
            suffix = "",
            prefix = function(diagnostic, _, _)
                local icon, highlight
                if diagnostic.severity == 1 then
                    icon = " "
                    highlight = "DiagnosticError"
                elseif diagnostic.severity == 2 then
                    icon = " "
                    highlight = "DiagnosticWarn"
                elseif diagnostic.severity == 3 then
                    icon = " "
                    highlight = "DiagnosticInfo"
                elseif diagnostic.severity == 4 then
                    icon = " "
                    highlight = "DiagnosticHint"
                end
                return icon, highlight
            end,
        },
        signs = signs,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        virtual_lines = false,
        severity_sort = true,
    })
end

lsp_config()

local lsp = {
    {
        "mrcjkb/rustaceanvim",
        lazy = false,
        init = function()
            for _, method in ipairs({ "textDocument/diagnostic", "workspace/diagnostic" }) do
                local default_diagnostic_handler = vim.lsp.handlers[method]
                vim.lsp.handlers[method] = function(err, result, context, config)
                    if err ~= nil and err.code == -32802 then
                        return
                    end
                    return default_diagnostic_handler(err, result, context, config)
                end
            end
        end,
    },
    {
        "mrcjkb/haskell-tools.nvim",
        lazy = false,
    },
    {
        "max397574/typst-tools.nvim",
        opts = {
            formatter = {
                conform_nvim = false,
                formatters = {
                    "typstfmt",
                    -- typstyle = {
                    --     command = "typstyle",
                    --     args = { "$FILENAME", "-i", "-l", "80", "--wrap-text" },
                    -- },
                },
            },
        },
        lazy = false,
    },
    require("omega.modules.lsp.lua_types"),
    {
        "chomosuke/typst-preview.nvim",
        ft = "typst",
        opts = {
            open_cmd = 'open -a qutebrowser "%s"',
            -- open_cmd = 'open -a Firefox "%s"',
            follow_cursor = true,
            dependencies_bin = {
                ["tinymist"] = "tinymist",
            },
        },
        build = function()
            require("typst-preview").update()
        end,
    },
}

return lsp
