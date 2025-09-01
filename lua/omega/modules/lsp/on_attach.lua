local on_attach = {}

function on_attach.setup(client, bufnr)
    if client.server_capabilities.codeActionProvider and client.name ~= "tinymist" then
        require("omega.modules.lsp.available_code_action").setup(bufnr)
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
end

return on_attach
