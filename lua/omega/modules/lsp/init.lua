local function lsp_config()
    local function on_attach(client, bufnr)
        require("omega.modules.lsp.on_attach").setup(client, bufnr)
    end

    require("omega.modules.lsp.lua").setup()
    require("omega.modules.lsp.python")

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            on_attach(vim.lsp.get_client_by_id(args.data.client_id), args.buf)
        end,
        group = vim.api.nvim_create_augroup("lsp-attach", {}),
    })
    -- require("lspconfig").tailwindcss.setup({ on_attach = on_attach })

    vim.api.nvim_set_hl(0, "DiagnosticHeader", { link = "Special" })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = require("omega.utils").border(),
        title = "Help",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = require("omega.utils").border(),
        title = "Signature",
    })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function(args)
            vim.lsp.start({
                name = "typst-lsp",
                cmd = { "typst-lsp" },
                root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf)),
                autostart = true,
                settings = {
                    exportPdf = "never",
                },
            })
        end,
    })

    -- jump to the first definition automatically if two definitions are on same line (for luals `local x = function()`)
    vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx)
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
                vim.lsp.util.jump_to_location(result[1], client.offset_encoding, false)
            else
                local title = "LSP locations"
                local items = vim.lsp.util.locations_to_items(result, client.offset_encoding)

                vim.fn.setqflist({}, " ", { title = title, items = items })
                vim.cmd("botright copen")

                -- todo: default action
            end
        else
            vim.lsp.util.jump_to_location(result, client.offset_encoding, false)
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
        severity_sort = true,
    })
end

lsp_config()

local lsp = {
    {
        "mrcjkb/rustaceanvim",
        lazy = false, -- This plugin is already lazy
        init = function()
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(client, bufnr)
                        require("omega.modules.lsp.on_attach").setup(client, bufnr)
                    end,
                },
            }
        end,
    },
    {
        "max397574/typst-tools.nvim",
        ft = "typst",
    },
    require("omega.modules.lsp.lua_types"),
}

return lsp
