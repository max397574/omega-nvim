local lua_cmd = {
    vim.fn.expand("~") .. "/lua-language-server/bin/lua-language-server",
}
local function on_attach(client, bufnr)
    -- require("omega.modules.langs.inlay_hints").setup_autocmd()
    require("omega.modules.lsp.on_attach").setup(client, bufnr)
end

local sumneko_lua_server = {
    on_attach = on_attach,
    cmd = lua_cmd,
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
            },
        },
    },
}

local lua_dev_plugins = {}
local runtime_path_completion = true
if not runtime_path_completion then
    sumneko_lua_server.settings.Lua.runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
        vim.fn.expand("~") .. "/.config/neovim_configs/omega/lua/?.lua",
    }
end
require("neodev").setup({
    library = {
        vimruntime = true,
        types = true,
        plugins = lua_dev_plugins, -- toggle this to get completion for require of all plugins
    },
    -- experimental = {
    --     pathStrict = true,
    -- },
    runtime_path = runtime_path_completion,
    lspconfig = sumneko_lua_server,
})
require("lspconfig")["sumneko_lua"].setup(sumneko_lua_server)
