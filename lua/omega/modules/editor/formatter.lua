return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            yaml = { "yamlfmt" },
            typst = { "typstfmt" },
            rust = { "rustfmt" },
            python = { "ruff_format" },
            markdown = { "prettier" },
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            callback = function(args)
                require("conform").format({ bufnr = args.buf })
            end,
        })
    end,
}
