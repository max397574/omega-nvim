---@type OmegaModule
local debugging = {}

debugging.configs = {
    ["nvim-dap"] = function()
        vim.fn.sign_define(
            "DapBreakpoint",
            { text = "⧐", texthl = "Error", linehl = "", numhl = "" }
        )
        vim.fn.sign_define(
            "DapStopped",
            { text = "⧐", texthl = "TSString", linehl = "", numhl = "" }
        )
        require("lazy").load("nvim-dap-ui")
        local dap = require("dap")
        dap.adapters.lldb = {
            type = "executable",
            command = vim.fn.expand("~")
                .. "/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/lldb/bin/lldb",
            name = "lldb",
        }
        dap.configurations.rust = {
            {
                name = "Launch",
                type = "lldb",
                request = "launch",
                program = function()
                    return vim.fn.iput("Path to executable: ", vim.fn.getcmw() .. "/" .. "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
            },
        }
        dap.configurations.lua = {
            {
                type = "nlua",
                request = "attach",
                name = "Attach to running Neovim instance",
            },
        }
        dap.adapters.nlua = function(callback, config)
            callback({
                type = "server",
                host = config.host or "127.0.0.1",
                port = config.port or 8086,
            })
        end
    end,
    ["nvim-dap-ui"] = function()
        require("dapui").setup({
            mappings = { toggle = "<tab>" },
        })
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end
    end,
    ["nvim-dap-virtual-text"] = function()
        require("nvim-dap-virtual-text").setup()
    end,
}

return debugging
