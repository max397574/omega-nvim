return {
    {
        "nvim-neorg/neorg",
        -- dir = "~/neovim_plugins/neorg/",
        -- commit = "d5965efe17e28a60cdbf14e97b87723a83f0c962",
        ft = "norg",
        cmd = { "Neorg" },
        opts = {
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {
                    config = {
                        icon_preset = "diamond",
                        icons = {
                            todo = {
                                done = { icon = "󰸞" },
                                on_hold = { icon = "󰏤" },
                                urgent = { icon = "󱈸" },
                                uncertain = { icon = "" },
                                recurring = { icon = "" },
                                pending = { icon = "" },
                            },
                        },
                    },
                },
                ["core.keybinds"] = {
                    config = {
                        default_keybinds = true,
                        neorg_leader = ",",
                    },
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            knowledge = "~/1_Knowledge",
                        },
                        default_workspace = "knowledge",
                    },
                },
                ["core.journal"] = {
                    config = {
                        workspace = "knowledge",
                        journal_folder = "journal",
                        strategy = "nested",
                    },
                },
                ["core.export"] = {},
                ["core.export.markdown"] = {
                    config = { extensions = "all" },
                },
                ["core.integrations.telescope"] = {},
                ["external.context"] = {},
                ["external.interim-ls"] = {
                    config = {
                        completion_provider = {
                            enable = true,
                            categories = false,
                        },
                    },
                },
                ["core.completion"] = {
                    config = { engine = { module_name = "external.lsp-completion" } },
                },
            },
        },
        dependencies = {
            { "nvim-neorg/neorg-telescope", dev = true },
            { "max397574/neorg-contexts" },
            { "benlubas/neorg-interim-ls" },
        },
        config = function(_, opts)
            require("lazy").load({ plugins = { "nvim-treesitter" } })
            require("neorg").setup(opts)
        end,
    },
}
