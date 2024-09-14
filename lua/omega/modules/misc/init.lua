return {
    { "elihunter173/dirbuf.nvim", config = true, cmd = { "Dirbuf" } },
    { "chrisgrieser/nvim-rip-substitute", opts = {}, lazy = false },
    {
        "HakonHarnes/img-clip.nvim",
        opts = { default = { dir_path = "imgs" } },
        keys = {
            {
                "<c-p>",
                function()
                    require("img-clip").paste_image()
                end,
                desc = "Paste Image",
            },
        },
    },
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
    {
        "ruifm/gitlinker.nvim",
        opts = {
            mappings = nil,
        },
        keys = {
            {
                "<leader>gy",
                function()
                    require("gitlinker").get_buf_range_url("n", {})
                end,
                desc = "Git Copy Permalink",
            },
            {
                "<leader>gy",
                function()
                    require("gitlinker").get_buf_range_url("v", {})
                end,
                mode = "x",
                desc = "Git Copy Permalink",
            },
        },
    },
}
