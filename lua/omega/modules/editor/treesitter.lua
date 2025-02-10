local treesitter = {
    "nvim-treesitter/nvim-treesitter",
    -- branch = "main",
    cmd = {
        "TSInstall",
        "TSBufEnable",
        "TSBufDisable",
        "TSEnable",
        "TSDisable",
        "TSModuleInfo",
    },
}

treesitter.opts = {
    highlight = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
        },
    },
}

function treesitter.config(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.cmd.TSBufEnable("highlight")
end

function treesitter.init()
    if not vim.tbl_contains({ "" }, vim.fn.expand("%")) then
        require("lazy").load({ plugins = { "nvim-treesitter" } })
    else
        vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
            callback = function()
                local file = vim.fn.expand("%")
                if not vim.tbl_contains({ "" }, file) then
                    require("lazy").load({ plugins = { "nvim-treesitter" } })
                end
            end,
        })
    end
end

return treesitter
