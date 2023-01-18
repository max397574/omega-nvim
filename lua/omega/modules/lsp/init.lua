local lsp = {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
}

lsp.dependencies = {
    {
        "folke/neodev.nvim",
        config = function()
            require("omega.modules.langs.lua")
        end,
    },
    {
        "simrat39/rust-tools.nvim",
        config = function()
            require("omega.modules.langs.rust")
        end,
    },
}

lsp.config = function()
    omega.lsp_active = true
    vim.api.nvim_set_hl(0, "DiagnosticHeader", { link = "Special" })
    vim.api.nvim_create_autocmd("CursorHold", {
        group = vim.api.nvim_create_augroup("lsp_float", {}),
        callback = function()
            vim.diagnostic.open_float()
        end,
    })
    local utils = require("omega.utils")

    local root_pattern = require("lspconfig.util").root_pattern

    local signs = {
        Error = "",
        Warn = "",
        Info = "",
        Hint = "",
    }
    for sign, icon in pairs(signs) do
        vim.fn.sign_define("DiagnosticSign" .. sign, {
            text = icon,
            texthl = "Diagnostic" .. sign,
            numhl = "Diagnostic" .. sign,
        })
    end
            require("omega.modules.langs.html")
    -- vim.lsp.handlers["textDocument/hover"] =
    --     vim.lsp.with(vim.lsp.handlers.hover, { border = utils.border() })
    -- vim.lsp.handlers["textDocument/signatureHelp"] =
    --     vim.lsp.with(vim.lsp.handlers.signature_help, { border = utils.border() })
    local lspconfig = require("lspconfig")
    local configs = require("lspconfig.configs")

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.completionItem.tagSupport = {
        valueSet = { 1 },
    }
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
    }
    capabilities.textDocument.codeAction = {
        dynamicRegistration = false,
        codeActionLiteralSupport = {
            codeActionKind = {
                valueSet = {
                    "",
                    "quickfix",
                    "refactor",
                    "refactor.extract",
                    "refactor.inline",
                    "refactor.rewrite",
                    "source",
                    "source.organizeImports",
                },
            },
        },
    }
    local function on_attach(client, bufnr)
        require("omega.modules.lsp.on_attach").setup(client, bufnr)
    end

    local servers = {
        pyright = {},
        jedi_language_server = {},
        dockerls = {},
        tsserver = {},
        cssls = { cmd = { "css-languageserver", "--stdio" } },
        rnix = {},
        clangd = {},
        julials = {},
        -- rust_analyzer = {
        --     root_dir = root_pattern("Cargo.toml", "rust-project.json", ".git"),
        -- },
        hls = {
            root_dir = root_pattern(
                ".git",
                "*.cabal",
                "stack.yaml",
                "cabal.project",
                "package.yaml",
                "hie.yaml"
            ),
        },
        texlab = require("omega.modules.langs.tex").config(),
        intelephense = {},
        vimls = {},
        zls = { cmd = { vim.fn.expand("~") .. "/zls/zig-out/bin/zls" } },
    }
    for server, config in pairs(servers) do
        lspconfig[server].setup(vim.tbl_deep_extend("force", {
            on_attach = on_attach,
            -- single_file_support = true,
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 150,
            },
        }, config))
    end
    local codes = {
        no_matching_function = {
            message = " Can't find a matching function",
            "redundant-parameter",
            "ovl_no_viable_function_in_call",
        },
        empty_block = {
            message = " That shouldn't be empty here",
            "empty-block",
        },
        missing_symbol = {
            message = " Here should be a symbol",
            "miss-symbol",
        },
        expected_semi_colon = {
            message = " Remember the `;` or `,`",
            "expected_semi_declaration",
            "miss-sep-in-table",
            "invalid_token_after_toplevel_declarator",
        },
        redefinition = {
            message = " That variable was defined before",
            "redefinition",
            "redefined-local",
        },
        no_matching_variable = {
            message = " Can't find that variable",
            "undefined-global",
            "reportUndefinedVariable",
        },
        trailing_whitespace = {
            message = " Remove trailing whitespace",
            "trailing-whitespace",
            "trailing-space",
        },
        unused_variable = {
            message = " Don't define variables you don't use",
            "unused-local",
        },
        unused_function = {
            message = " Don't define functions you don't use",
            "unused-function",
        },
        useless_symbols = {
            message = " Remove that useless symbols",
            "unknown-symbol",
        },
        wrong_type = {
            message = " Try to use the correct types",
            "init_conversion_failed",
        },
        undeclared_variable = {
            message = " Have you delcared that variable somewhere?",
            "undeclared_var_use",
        },
        lowercase_global = {
            message = " Should that be a global? (if so make it uppercase)",
            "lowercase-global",
        },
    }

    vim.diagnostic.config({
        float = {
            focusable = false,
            border = utils.border(),
            scope = "line",
            format = function(diagnostic)
                -- dump(diagnostic)
                if diagnostic.user_data == nil then
                    return diagnostic.message
                elseif vim.tbl_isempty(diagnostic.user_data) then
                    return diagnostic.message
                end
                local code = diagnostic.user_data.lsp.code
                for _, table in pairs(codes) do
                    if vim.tbl_contains(table, code) then
                        return table.message
                    end
                end
                return diagnostic.message
            end,
            header = { "Cursor Diagnostics:", "DiagnosticHeader" },
            suffix = "",
            prefix = function(diagnostic, i, total)
                local icon, highlight
                if diagnostic.severity == 1 then
                    icon = ""
                    highlight = "DiagnosticError"
                elseif diagnostic.severity == 2 then
                    icon = ""
                    highlight = "DiagnosticWarn"
                elseif diagnostic.severity == 3 then
                    icon = ""
                    highlight = "DiagnosticInfo"
                elseif diagnostic.severity == 4 then
                    icon = ""
                    highlight = "DiagnosticHint"
                end
                return i .. "/" .. total .. " " .. icon .. "  ", highlight
            end,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
    })
end

return lsp
