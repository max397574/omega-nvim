vim.env.LAZY_STDPATH = ".repro"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

vim.api.nvim_set_hl(0, "SnacksPickerPreviewTitle", { bg = "#ffab00" })

require("lazy.minit").repro({
    spec = {
        {
            "folke/snacks.nvim",
            opts = {
                picker = {
                    layout = {
                        cycle = true,
                        layout = {
                            box = "horizontal",
                            dim = false,
                            width = 0.8,
                            min_width = 120,
                            height = 0.8,
                            {
                                border = "rounded",
                                box = "vertical",
                                { win = "input", height = 1 },
                                { win = "list", border = "none" },
                            },
                            {
                                win = "preview",
                                title = { { "󰈔 {preview} ", "SnacksPickerPreviewTitle" } },
                                border = "rounded",
                                -- Uncomment the following part for repro
                                -- ======================================
                                wo = {
                                  number = true,
                                  relativenumber = false,
                                  signcolumn = "no",
                                  statuscolumn = "",
                                },

                                width = 0.5,
                            },
                        },
                    },
                },
            },
        },
    },
})
