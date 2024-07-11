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

treesitter.dependencies = {
    { "nvim-treesitter/nvim-treesitter-textobjects" },
}

treesitter.opts = {
    highlight = { enable = true },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["as"] = "@scope",
            },
        },
    },
}

function treesitter.config(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    vim.cmd.TSBufEnable("highlight")
end

function treesitter.init()
    if not vim.tbl_contains({ "" }, vim.fn.expand("%")) then
        require("lazy").load({ plugins = { "nvim-treesitter", "nvim-treesitter-textobjects" } })
    else
        vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
            callback = function()
                local file = vim.fn.expand("%")
                if not vim.tbl_contains({ "" }, file) then
                    require("lazy").load({ plugins = { "nvim-treesitter", "nvim-treesitter-textobjects" } })
                end
            end,
        })
    end
end

return treesitter
