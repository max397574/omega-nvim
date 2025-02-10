local config = require("omega.config")
local telescope = {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
}

---@param prompt_bufnr number
local function copy_file_name(prompt_bufnr)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local picker = action_state.get_current_picker(prompt_bufnr)
    local entries = picker:get_multi_selection()
    vim.fn.setreg("+", entries[1][1])
    actions.close(prompt_bufnr)
end

local mappings = {
    ["<C-j>"] = "move_selection_next",
    ["<C-k>"] = "move_selection_previous",
    ["<C-d>"] = "preview_scrolling_up",
    ["<C-f>"] = "preview_scrolling_down",
    ["<C-h>"] = "which_key",
    ["<C-q>"] = function(...)
        require("telescope.actions").send_selected_to_qflist(...)
        require("telescope.actions").open_qflist(...)
    end,
    ["<C-a>"] = function(...)
        require("telescope.actions").send_to_qflist(...)
        require("telescope.actions").open_qflist(...)
    end,
    ["<C-y>"] = function(...)
        copy_file_name(...)
    end,
    ["<C-o>"] = "select_vertical",
    ["<C-l>"] = function(...)
        require("telescope.actions.layout").toggle_preview(...)
    end,
    ["<c-c>"] = function(...)
        require("telescope._extensions.file_browser.actions").create(...)
    end,
    ["<a-cr>"] = function(...)
        require("telescope._extensions.file_browser.actions").create_from_prompt(...)
    end,
}

telescope.opts = {
    defaults = {
        file_ignore_patterns = {},
        initial_mode = "insert",
        sorting_strategy = "ascending",
        prompt_prefix = "   ",
        selection_caret = "  ",
        get_status_text = function()
            return ""
        end,
        path_display = {
            shorten = {
                len = 4,
                exclude = { -1 },
            },
        },
        layout_config = {
            preview_cutoff = 90,
            prompt_position = "top",
            width = 0.85,
            height = 0.9,
            horizontal = {
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
        },
        mappings = {
            n = mappings,
            i = mappings,
        },
    },
    pickers = {
        find_files = {
            -- stylua: ignore
            find_command = {
                "rg", "-g", "!.git", "-g", "!.jj", "-g", "!*.aux", "-g", "!*.toc", "-g", "!*.out", "-g", "!*.log", "-g", "!*.png",
                "-g", "!*.jpg", "-g", "!*.jpeg", "-g", "!.repro", "-g", "!*.idx", "-g", "!*.ind", "-g", "!*.ilg", "-g", "!*.fls",
                "-g", "!*.pygtex", "-g", "!*.pygstyle", "-g", "!*.synctex.gz", "-g", "!*.fdb_latexmk",
                -- "-g", "!build/",
                "-g", "!node_modules/",
                "-g", "!.docusaurus/", "-g", "!target/", "-g", "!.DS_Store", "--files", "--hidden", "--no-ignore", "--smart-case",
            },
        },
        buffers = {
            theme = "dropdown",
            height = 0.3,
            width = 0.5,
            preview = {
                hide_on_startup = true,
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    },
}

telescope.dependencies = {
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-file-browser.nvim" },
}

if config.modules.picker == "telescope" then
    telescope.keys = {
        {
            "<c-r>",
            mode = "c",
            "<Plug>(TelescopeFuzzyCommandSearch)",
        },
        {
            "<leader>ff",
            mode = "n",
            function()
                require("telescope.builtin").find_files()
            end,
            desc = "Find file",
        },
        {
            "<leader>/",
            function()
                require("telescope.builtin").live_grep()
            end,
            desc = "Live Grep",
        },
        {
            "<leader>.",
            function()
                require("telescope").extensions.file_browser.file_browser()
            end,
            desc = "File Browser",
        },
        {
            "<leader>hh",
            function()
                require("telescope.builtin").help_tags()
            end,
            desc = "Help tags",
        },
        {
            "<c-s>",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find()
            end,
            desc = "Current buffer fuzzy find",
        },
        {
            "<leader>,",
            function()
                require("telescope.builtin").buffers()
            end,
            desc = "Buffers",
        },
    }
end

function telescope.config(_, opts)
    require("telescope").setup(opts)
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("file_browser")
end

return telescope
