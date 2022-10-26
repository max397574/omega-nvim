local html = {}

html.plugins = {}

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

local function on_attach(client, bufnr)
    require("omega.modules.lsp.on_attach").setup(client, bufnr)
end

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

local html_server = { cmd = { "html-languageserver", "--stdio" } }

lspconfig.html.setup(vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    -- single_file_support = true,
    capabilities = capabilities,
    flags = {
        debounce_text_changes = 150,
    },
}, html_server))

configs.emmet_ls = {
    default_config = {
        cmd = { "ls_emmet", "--stdio" },
        filetypes = {
            "html",
            "css",
            "scss",
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "haml",
            "xml",
            "xsl",
            "pug",
            "slim",
            "sass",
            "stylus",
            "less",
            "sss",
        },
        root_dir = function(fname)
            return vim.loop.cwd()
        end,
        settings = {},
    },
}

lspconfig.emmet_ls.setup({ capabilities = capabilities })

return html
