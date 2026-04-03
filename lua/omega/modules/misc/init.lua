local cp_path = "~/4_ComputerScience/1_Programming/01_Rust/CP/"
return {
    { "nvim-lua/plenary.nvim" },
    { "nvzone/volt" },
    {
        "nvzone/floaterm",
        opts = {
            size = { h = 70, w = 94 },
        },
        cmd = "FloatermToggle",
        keys = {
            {
                "<leader>r",
                mode = { "n" },
                function()
                    if vim.bo.filetype ~= "rust" then
                        return
                    end
                    vim.cmd.w()
                    pcall(function()
                        require("lazy").load({ plugins = { "floaterm" } })
                    end)
                    local command
                    if vim.tbl_isempty(vim.fs.find("cargo.toml", { upward = true })) then
                        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                        local file = io.open(vim.fn.stdpath("data") .. "/temp", "w")
                        if not file then
                            return
                        end
                        for _, line in ipairs(lines) do
                            file:write(line)
                        end
                        file:close()
                        command = "rustc --edition 2024 -o "
                            .. vim.fn.stdpath("data")
                            .. "/tmp "
                            .. vim.fn.expand("%")
                            .. " && "
                            .. vim.fn.stdpath("data")
                            .. "/tmp"
                            .. "&& rm "
                            .. vim.fn.stdpath("data")
                            .. "/tmp"

                        require("floaterm").toggle()
                        require("floaterm.api").send_cmd({ cmd = command })
                        print("Running: " .. command)
                        return
                    end
                    if command then
                        require("floaterm").toggle()
                        require("floaterm.api").send_cmd({ cmd = command })
                        print("Running: " .. command)
                    end
                end,
            },
            {
                "<c-t>",
                mode = { "n", "t" },
                function()
                    vim.cmd.FloatermToggle()
                end,
            },
        },
    },
    { "folke/todo-comments.nvim", opts = {}, event = "VeryLazy" },
    {
        "HakonHarnes/img-clip.nvim",
        opts = {
            default = {
                dir_path = "imgs",
                file_name = function()
                    local file_name = vim.fn.input("File name: ")
                    local timestamp = os.date("%Y-%m-%d-%H-%M-%S")
                    if not file_name or #file_name <= 0 then
                        return timestamp
                    else
                        return file_name .. "-" .. timestamp
                    end
                end,
                prompt_for_file_name = false,
            },
        },
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
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        opts = {},
    },
    { "onsails/lspkind.nvim", lazy = false, opts = {} },
}
