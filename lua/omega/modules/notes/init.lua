return {
    {
        "nvim-neorg/neorg",
        -- dir = "~/neovim_plugins/neorg/",
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
                        workspace = "notes",
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
            },
        },
        dependencies = {
            { "nvim-neorg/neorg-telescope" },
            { "max397574/neorg-contexts" },
        },
        config = function(_, opts)
            require("lazy").load({ plugins = { "nvim-treesitter" } })
            require("neorg").setup(opts)
        end,
    },
}
