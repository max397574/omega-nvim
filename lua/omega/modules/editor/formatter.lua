return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            yaml = { "yamlfmt" },
            rust = { "rustfmt" },
            python = { "ruff_format" },
            markdown = { "prettier" },
            typst = { "typstyle" },
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "typst",
            once = true,
            callback = function()
                require("conform").formatters.typstyle = {
                    command = "typstyle",
                    -- args = { "$FILENAME", "-i", "-l", "80", "--wrap-text" },
                    -- args = { "$FILENAME", "--wrap-text", "-l", "80" },
                    args = { "--wrap-text", "-l", "80" },
                    stdin = true,
                }
            end,
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })
    end,
}
