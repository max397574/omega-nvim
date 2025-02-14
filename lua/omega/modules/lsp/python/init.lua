local python = {}

local function on_attach(client, bufnr)
    require("omega.modules.lsp.on_attach").setup(client, bufnr)
end

local py_utils = require("omega.modules.lsp.python.utils")

local root_pattern = require("omega.modules.lsp.util").root_pattern

local basedpyright_root_files = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "main.py",
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
    ".jj",
}

local ruff_root_files = {
    "pyproject.toml",
    "ruff.toml",
    "main.py",
    ".ruff.toml",
    ".git",
    ".jj",
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.lsp.start({
            name = "basedpyright",
            cmd = { "basedpyright-langserver", "--stdio" },
            root_dir = vim.fs.root(0, basedpyright_root_files),
            settings = {
                pyright = {
                    disableOrganizeImports = true,
                },
                basedpyright = { analysis = { typeCheckingMode = "off" } },
                python = {
                    analysis = {
                        ignore = { "*" },
                    },
                },
            },
        })
        vim.lsp.start({
            name = "ruff",
            cmd = { "ruff", "server" },
            root_dir = vim.fs.root(0, ruff_root_files),
            init_options = {
                settings = {
                    logFile = "~/ruff.log",
                    logLevel = "trace",
                },
            },
        })
    end,
})

-- TODO: readd
-- for server, config in pairs(servers) do
--     require("lspconfig")[server].setup(config)
-- end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == "ruff" then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = "LSP: Disable hover capability from Ruff",
})

return python
