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
    "requirements.txt",
    "Pipfile",
    "pyrightconfig.json",
    ".git",
    ".jj",
}

local ruff_root_files = {
    "pyproject.toml",
    "ruff.toml",
    ".ruff.toml",
    ".git",
    ".jj",
}

local servers = {
    ruff = {
        root_dir = function(fname)
            return root_pattern(unpack(ruff_root_files))(fname)
        end,
        on_attach = on_attach,
        init_options = {
            settings = {
                logFile = "~/ruff.log",
                logLevel = "trace",
            },
        },
        on_new_config = function(new_config, new_root_dir)
            new_config.settings.python.pythonPath = vim.fn.exepath("python")
            new_config.cmd_env.PATH = py_utils.env(new_root_dir) .. new_config.cmd_env.PATH
        end,
    },
    basedpyright = {
        root_dir = function(fname)
            return root_pattern(unpack(basedpyright_root_files))(fname)
        end,
        on_attach = on_attach,
        settings = {
            pyright = {
                disableOrganizeImports = true,
            },
            python = {
                analysis = {
                    ignore = { "*" },
                },
            },
        },
        on_new_config = function(new_config, new_root_dir)
            new_config.settings.python.pythonPath = vim.fn.exepath("python")
            new_config.cmd_env.PATH = py_utils.env(new_root_dir) .. new_config.cmd_env.PATH
        end,
    },
}

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
