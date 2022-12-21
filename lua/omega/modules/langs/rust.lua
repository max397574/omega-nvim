local rust_lsp = {}

rust_lsp.configs = {
    ["rust-tools.nvim"] = function()
        require("lazy").load("nvim-dap")
        local function on_attach(client, bufnr)
            require("omega.modules.lsp.on_attach").setup(client, bufnr)
        end
        local extension_path = vim.fn.expand("~")
            .. "/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = extension_path .. "lldb/bin/lldb"
        require("rust-tools").setup({
            dap = {
                adapter = require("rust-tools.dap").get_codelldb_adapter(
                    codelldb_path,
                    liblldb_path
                ),
            },
            server = {
                on_attach = on_attach,
                standalone = true,
                settings = {
                    ["rust-analyzer"] = {
                        editor = {
                            formatOnType = true,
                        },
                        checkOnSave = {
                            command = "clippy",
                        },
                        hover = {
                            actions = {
                                references = {
                                    enable = true,
                                },
                            },
                        },
                    },
                },
            },
        })
    end,
}

return rust_lsp
