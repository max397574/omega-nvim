local function on_attach(client, bufnr)
    require("omega.modules.lsp.on_attach").setup(client, bufnr)
end

local root_pattern = require("omega.modules.lsp.util").root_pattern

local settings = {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    "vim",
                    "omega",
                    "hs",
                    "lvim",
                    "neorg",
                },
            },
            completion = {
                callSnippet = "Replace",
                displayContext = 5,
                showWord = "Enable",
            },
            hint = {
                enable = true,
                paramType = true,
                setType = true,
                paramName = true,
                arrayIndex = "Enable",
            },
            hover = {
                expandAlias = false,
            },
            type = {
                castNumberToInteger = true,
            },
            workspace = {
                checkThirdParty = false,
                maxPreload = 1000,
                preloadFileSize = 1000,
                library = {
                    vim.fn.stdpath("config") .. "/lua/omega/types",
                    vim.fn.stdpath("config") .. "/lua",
                },
            },
        },
    },
}

local root_files = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
}

local function setup()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function(args)
            local function root_dir(fname)
                local root = root_pattern(unpack(root_files))(fname)
                if root and root ~= vim.env.HOME then
                    return root
                end
                root = root_pattern("lua/")(fname)
                if root then
                    return root
                end
                return vim.fs.find(
                    ".git",
                    { type = "directory", path = vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf)) }
                ) or vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf))
            end
            vim.lsp.start({
                name = "lua_ls",
                cmd = { "lua-language-server" },
                root_dir = root_dir(vim.api.nvim_buf_get_name(args.buf)),
                autostart = true,
                single_file_support = true,
                log_level = vim.lsp.protocol.MessageType.Warning,
                -- settings = {
                --     exportPdf = "never",
                -- },
            })
        end,
    })
end

return { setup = setup }
