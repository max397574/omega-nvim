local on_attach = {}

local function lsp_highlight_document(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
            buffer = bufnr,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                vim.lsp.buf.clear_references()
            end,
            buffer = bufnr,
        })
    end
end

function on_attach.setup(client, bufnr)
    if client.server_capabilities.codeActionProvider then
        require("omega.modules.lsp.available_code_action").setup(bufnr)
    end
    local opts = { noremap = true, silent = true, buffer = bufnr }
    -- TODO: remove default gr mappings after 0.11 release
    vim.keymap.set("n", "grn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gra", vim.lsp.buf.code_action, opts)
    vim.keymap.set("v", "gra", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "grr", vim.lsp.buf.references, opts)
    vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, opts)

    vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    lsp_highlight_document(client, bufnr)
end

return on_attach
