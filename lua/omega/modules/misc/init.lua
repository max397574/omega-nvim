return {
    { "elihunter173/dirbuf.nvim", config = true, cmd = { "Dirbuf" } },
    { "max397574/colorscheme_switcher" },
    {
        "xiyaowong/nvim-colorizer.lua",
        cmd = { "ColorizerAttachToBuffer" },
        config = function()
            require("colorizer").setup({
                "*",
            }, {
                mode = "foreground",
                hsl_fn = true,
            })
            vim.cmd.ColorizerAttachToBuffer()
        end,
        keys = {
            {
                "<leader>vc",
                function()
                    vim.cmd.ColorizerAttachToBuffer()
                end,
                desc = "View Colors",
            },
        },
    },
    { "max397574/tmpfile.nvim" },
}
