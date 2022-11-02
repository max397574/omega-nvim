local modules = {}
local set_keybindings
set_keybindings = function(bindings, prefix, mode)
    for key, binding in pairs(bindings) do
        if key == "name" then
        elseif vim.tbl_contains({ "function", "string" }, type(binding)) then
            vim.keymap.set(mode, prefix .. key, binding, {})
        elseif
            type(binding) == "table"
            and #binding == 2
            and (vim.tbl_contains({ "function", "string" }, type(binding[1])))
            and type(binding[2]) == "string"
        then
            vim.keymap.set(mode, prefix .. key, binding[1], {})
        elseif type(binding) == "table" then
            set_keybindings(binding, prefix .. key, mode)
        end
    end
end

local function parse_keybindings(keybindings)
    if not keybindings then
        return
    end
    for _, keybind_table in ipairs(keybindings) do
        set_keybindings(keybind_table[1], keybind_table[2]["prefix"], keybind_table[2]["mode"])
    end
end

function modules.setup()
    local module_sections = {
        ["ui"] = {
            "blankline",
            "bufferline",
            "devicons",
            "heirline",
            "noice",
            "themes",
            -- "notify",
        },
        ["mappings"] = {
            "which_key",
        },
        ["core"] = {
            "omega",
        },
        ["langs"] = {
            "lua",
            "log",
            "html",
            -- "ntangle",
            "main",
            "python",
            "rust",
            "swift",
            "debugging",
        },
        ["completion"] = {
            "annotations",
            "autopairs",
            "cmp",
            "snippets",
            "neocomplete",
        },
        ["misc"] = {
            "colorizer",
            "colorscheme_switcher",
            "colortils",
            "comment",
            -- "dynamic_help",
            "formatter",
            "gitlinker",
            "gitsigns",
            "harpoon",
            "help_files",
            "holo",
            "image",
            "insert_utils",
            "lightspeed",
            "mkdir",
            "nabla",
            "neorg",
            "nvim-tree",
            "paperplanes",
            "sj",
            "surround",
            "symbols_outline",
            "telescope",
            "todo",
            "toggleterm",
            -- "tomato",
            "treesitter",
            "trouble",
            "undotree",
            "venn",
            -- "windows",
        },
        ["games"] = {
            "vimbegood",
            "wordle",
        },
    }
    for section, sec_modules in pairs(module_sections) do
        omega.modules[section] = {}
        for _, module in ipairs(sec_modules) do
            local ok, result = xpcall(
                require,
                debug.traceback,
                string.format("omega.modules.%s.%s", section, module)
            )
            if ok then
                omega.modules[section][module] = result
            else
                print(result)
            end
        end
    end
    local packer = require("packer")
    packer.init({
        compile_path = vim.fn.stdpath("data") .. "/plugin/packer_compiled.lua",
        git = {
            clone_timeout = 300,
            subcommands = {
                -- Prevent packer from downloading all branches metadata to reduce cloning cost
                -- for heavy size plugins like plenary (removed the '--no-single-branch' git flag)
                install = "clone --depth %i --progress",
            },
        },
        max_jobs = 10,
        display = {
            done_sym = "",
            error_syn = "×",
            open_fn = function()
                return require("packer.util").float({
                    border = require("omega.utils").border(),
                })
            end,
            keybindings = {
                toggle_info = "<TAB>",
            },
        },
        profile = {
            enable = true,
        },
        snapshot = "stable",
    })

    packer.reset()
end

function modules.load()
    local use = require("packer").use
    if not omega.config.use_impatient then
        omega.modules.core.omega.plugins["impatient.nvim"] = nil
    end
    for _, section in pairs(omega.modules) do
        for _, mod in pairs(section) do
            if not mod.plugins then
                return
            end
            for plugin, packer_spec in pairs(mod.plugins) do
                if
                    mod.configs
                    and mod.configs[plugin]
                    and type(mod.configs[plugin]) == "function"
                then
                    omega.plugin_configs[plugin] = mod.configs[plugin]
                    packer_spec["config"] = function(name)
                        omega.plugin_configs[name]()
                    end
                end
                use(packer_spec)
            end
        end
    end
    for _, section in pairs(omega.modules) do
        for _, mod in pairs(section) do
            if mod.keybindings and type(mod.keybindings) == "table" then
                parse_keybindings(mod.keybindings)
            elseif mod.keybindings and type(mod.keybindings) == "function" then
                mod.keybindings()
            end
        end
    end
end

function modules.bootstrap_packer()
    local has_packer = pcall(require, "packer")
    if not has_packer then
        -- Packer Bootstrapping
        local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
        if vim.fn.isdirectory(packer_path) == 0 then
            vim.notify("Bootstrapping packer.nvim, please wait ...")
            vim.fn.system({
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                packer_path,
            })
        end

        vim.cmd.packadd("packer.nvim")
    end
end

return modules
