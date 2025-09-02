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
                    local exp = vim.fn.expand

                    local files = {
                        python = function()
                            return require("omega.modules.lsp.python").get_run_command()
                        end,
                        julia = function()
                            return "julia " .. exp("%:t")
                        end,
                        lua = function()
                            return "lua " .. exp("%:t")
                        end,
                        applescript = function()
                            return "osascript " .. exp("%:t")
                        end,
                        c = function()
                            return "gcc -o temp " .. exp("%:t") .. " && ./temp && rm ./temp"
                        end,
                        cpp = function()
                            return "clang++ -o temp " .. exp("%:t") .. " && ./temp && rm ./temp"
                        end,
                        java = function()
                            return "javac " .. exp("%:t") .. " && java " .. exp("%:t:r") .. " && rm *.class"
                        end,
                        rust = function()
                            return "cargo run"
                        end,
                        javascript = function()
                            return "node " .. exp("%:t")
                        end,
                        typescript = function()
                            return "tsc " .. exp("%:t") .. " && node " .. exp("%:t:r") .. ".js"
                        end,
                    }
                    vim.cmd.w()
                    local command = files[vim.bo.filetype]()
                    pcall(function()
                        require("lazy").load({ plugins = { "floaterm" } })
                    end)
                    if vim.bo.filetype == "rust" then
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
                    end
                    if command ~= nil then
                        require("floaterm").toggle()
                        require("floaterm.api").send_cmd({ cmd = command })
                        print("Running: " .. command)
                    end
                end,
                desc = " Run File",
            },
            "<c-g>",
            {
                "<c-g>",
                mode = { "t" },
                function()
                    vim.cmd.ToggleTerm()
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
    -- {
    --     "max397574/codeforces-nvim",
    --     opts = {
    --         extension = "rs",
    --         use_term_toggle = false,
    --         cf_path = "~/4_ComputerScience/1_Programming/01_Rust/CP/CodeForces",
    --         timeout = 5000,
    --         compiler = {
    --             rs = { "rustc", "@.cpp" },
    --         },
    --         run = {
    --             rs = { "@" },
    --         },
    --         notify = function(title, message, type)
    --             if message == nil then
    --                 vim.notify(title, type, { render = "minimal" })
    --             else
    --                 vim.notify(message, type, {
    --                     title = title,
    --                 })
    --             end
    --         end,
    --         paths = {
    --             contests = cp_path .. "CodeForces/",
    --             tests = cp_path .. "CodeForces/tests/",
    --             solutions = cp_path .. "CodeForces/solutions/",
    --             templates = cp_path,
    --         },
    --     },
    --     cmd = { "EnterContest", "TestCurrent" },
    -- },
    {
        "HakonHarnes/img-clip.nvim",
        opts = {
            default = {
                dir_path = "imgs",
                file_name = function()
                    local file_name = vim.fn.input("File name: ")
                    local timestamp = os.date("%Y-%m-%d-%H-%M-%S")
                    return file_name .. "-" .. timestamp
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
        "lewis6991/gitsigns.nvim",
        lazy = false,
        opts = {},
    },
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
    { "onsails/lspkind.nvim", lazy = false, opts = {} },
}
