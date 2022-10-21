--[[
This is what I do with packer + lspconfig.
{
  "microsoft/python-type-stubs",
  opt = true,
},

Then on lspconfig opts, 
  before_init = function(_, config)
    local stub_path = _G.join_paths(
      _G.get_runtime_dir(),
      "site",
      "pack",
      "packer",
      "opt",
      "python-type-stubs"
    )
    config.settings.python.analysis.stubPath = stub_path
  end
--]]
local python = {}
python.plugins = {
    ["nvim-lsp-installer"] = {
        "williamboman/nvim-lsp-installer",
        ft = "python",
    },
}

python.configs = {
    ["nvim-lsp-installer"] = function()
        do
            require("nvim-lsp-installer").setup({})
            local util = require("lspconfig.util")
            local lsp_util = require("vim.lsp.util")
            local configs = require("lspconfig.configs")
            local servers = require("nvim-lsp-installer.servers")
            local server = require("nvim-lsp-installer.server")
            local path = require("nvim-lsp-installer.core.path")

            local server_name = "pylance"

            local root_files = {
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                ".git",
                "pyrightconfig.json",
            }

            local function extract_method()
                local range_params = lsp_util.make_given_range_params(nil, nil, 0, {})
                local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
                local params = {
                    command = "pylance.extractMethod",
                    arguments = arguments,
                }
                vim.lsp.buf.execute_command(params)
            end

            local function extract_variable()
                local range_params = lsp_util.make_given_range_params(nil, nil, 0, {})
                local arguments = { vim.uri_from_bufnr(0):gsub("file://", ""), range_params.range }
                local params = {
                    command = "pylance.extractVarible",
                    arguments = arguments,
                }
                vim.lsp.buf.execute_command(params)
            end

            local function organize_imports()
                local params = {
                    command = "pyright.organizeimports",
                    arguments = { vim.uri_from_bufnr(0) },
                }
                vim.lsp.buf.execute_command(params)
            end

            local function on_workspace_executecommand(err, actions, ctx)
                if ctx.params.command:match("WithRename") then
                    ctx.params.command = ctx.params.command:gsub("WithRename", "")
                    vim.lsp.buf.execute_command(ctx.params)
                end
            end

            configs[server_name] = {
                default_config = {
                    filetypes = { "python" },
                    root_dir = util.root_pattern(unpack(root_files)),
                    cmd = { "py" },
                    single_file_support = true,
                    settings = {
                        python = {
                            analysis = {
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "workspace",
                            },
                        },
                    },
                    handlers = {
                        ["workspace/executeCommand"] = on_workspace_executecommand,
                    },
                },
                commands = {
                    PylanceExtractMethod = {
                        extract_method,
                        description = "Extract Method",
                    },
                    PylanceExtractVarible = {
                        extract_variable,
                        description = "Extract Variable",
                    },
                    PylanceOrganizeImports = {
                        organize_imports,
                        description = "Organize Imports",
                    },
                },
            }

            local root_dir = server.get_server_root_path(server_name)

            local function installer(ctx)
                local script = [[
    version=$(curl -s -c cookies.txt 'https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance' | grep --extended-regexp '"version":"[0-9\.]*"' -o | head -1 | sed 's/"version":"\([0-9\.]*\)"/\1/');
    curl -s "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/vscode-pylance/$version/vspackage" \
        -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.110 Safari/537.36' \
        -j -b cookies.txt --compressed --output "ms-python.vscode-pylance-${version}";
    unzip "ms-python.vscode-pylance-$version";
    ~/node_modules/.bin/js-beautify -r extension/dist/server.bundle.js;
    sed -i -r "0,/(if \(\!process\[[^ ]*\]\[[^ ]*\]\) return \!0x)1;$/ s//\10;/" extension/dist/server.bundle.js;
    perl -i -0777 -pe "s/(for \(const .* of process.*\)\n\s+if \(.*\) return \!0)x1;/\1x0;/" extension/dist/server.bundle.js;
    rm "ms-python.vscode-pylance-$version";
  ]]

                local prefix = "set -euo pipefail;"
                ctx.spawn.bash({ "-c", prefix .. script })
            end

            local custom_server = server.Server:new({
                name = server_name,
                root_dir = root_dir,
                installer = installer,
                default_options = {
                    cmd = {
                        "node",
                        path.concat({ root_dir, "extension/dist/server.bundle.js" }),
                        "--stdio",
                    },
                },
            })
            servers.register(custom_server)
        end
        do
            local path = require("lspconfig/util").path
            -- local utils = require("plugins.config.lsp.utils")
            local autocmds = {
                DocumentHighlightAU = function()
                    local group = vim.api.nvim_create_augroup("DocumentHighlight", {})
                    vim.api.nvim_create_autocmd("CursorHold", {
                        group = group,
                        buffer = 0,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd("CursorMoved", {
                        group = group,
                        buffer = 0,
                        callback = vim.lsp.buf.clear_references,
                    })
                end,

                -- SemanticTokensAU = function()
                --     local group = vim.api.nvim_create_augroup("SemanticTokens", {})
                --     vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                --         group = group,
                --         buffer = 0,
                --         callback = vim.lsp.buf.semantic_tokens_full,
                --     })
                -- end,

                DocumentFormattingAU = function()
                    local group = vim.api.nvim_create_augroup("Formatting", {})
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = group,
                        buffer = 0,
                        callback = function()
                            if vim.g.format_on_save then
                                vim.lsp.buf.format({ timeout_ms = 3000 })
                            end
                        end,
                    })
                end,

                InlayHintsAU = function()
                    require("omega.modules.langs.inlay_hints").setup_autocmd()
                end,
            }
            local utils = {
                autocmds = autocmds,
                common = {
                    on_attach = function(client, bufnr)
                        require("omega.modules.lsp.on_attach").setup(client, bufnr)
                        --     local function buf_set_option(...)
                        --         vim.api.nvim_buf_set_option(bufnr, ...)
                        --     end
                        --     buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
                        --
                        --     mappings.setup(client.name)
                        --
                        --     if client.server_capabilities.definitionProvider then
                        --         vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
                        --     end
                        --
                        --     if client.server_capabilities.documentHighlightProvider then
                        --         autocmds.DocumentHighlightAU()
                        --     end
                        --
                        --     if client.server_capabilities.documentFormattingProvider then
                        --         autocmds.DocumentFormattingAU()
                        --     end
                    end,
                },
            }
            local lspconfig = require("lspconfig")

            local function get_python_path(workspace)
                -- Use activated virtualenv.
                if vim.env.VIRTUAL_ENV then
                    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
                end

                -- Find and use virtualenv via poetry in workspace directory.
                local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
                if match ~= "" then
                    local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
                    return path.join(venv, "bin", "python")
                end

                -- Fallback to system Python.
                return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
            end

            local configs = {
                on_attach = function(client, bufnr)
                    utils.common.on_attach(client, bufnr)
                    utils.autocmds.InlayHintsAU()
                    -- utils.autocmds.SemanticTokensAU()
                end,
                capabilities = vim.lsp.protocol.make_client_capabilities(),
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            completeFunctionParens = true,
                            indexing = false,
                            inlayHints = {
                                variableTypes = true,
                                functionReturnTypes = true,
                            },
                        },
                    },
                },
                before_init = function(_, config)
                    local stub_path = require("lspconfig/util").path.join(
                        vim.fn.stdpath("data"),
                        "site",
                        "pack",
                        "packer",
                        "opt",
                        "python-type-stubs"
                    )
                    config.settings.python.analysis.stubPath = stub_path
                end,
                on_init = function(client)
                    client.config.settings.python.pythonPath =
                        get_python_path(client.config.root_dir)
                end,
            }

            lspconfig.pylance.setup(configs)
        end
    end,
}

return python
