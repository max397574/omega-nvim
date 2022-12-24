return {
    ["colorscheme_switcher"] = function()
        local pickers = require("telescope.pickers")
        local conf = require("telescope.config").values
        local finders = require("telescope.finders")

        local action_state = require("telescope.actions.state")
        local tele_utils = require("telescope.utils")
        local previewers = require("telescope.previewers")
        local utils = require("omega.utils")

        local function base_16_finder(opts)
            opts = opts or {}
            local change_theme = function()
                local entry = action_state.get_selected_entry()
                if entry ~= nil then
                    require("omega.colors").init(entry[1], true)
                    -- require("colorscheme_switcher").new_scheme()
                end
                vim.fn.feedkeys(utils.t("<ESC><ESC>"), "i")
            end

            -- buffer number and name
            local bufnr = vim.api.nvim_get_current_buf()
            local bufname = vim.api.nvim_buf_get_name(bufnr)

            local previewer

            -- in case its not a normal buffer
            if vim.fn.buflisted(bufnr) ~= 1 then
                local deleted = false
                local function del_win(win_id)
                    if win_id and vim.api.nvim_win_is_valid(win_id) then
                        tele_utils.buf_delete(vim.api.nvim_win_get_buf(win_id))
                        pcall(vim.api.nvim_win_close, win_id, true)
                    end
                end

                previewer = previewers.new({
                    preview_fn = function(_, entry, status)
                        if not deleted then
                            deleted = true
                            del_win(status.preview_win)
                            del_win(status.preview_border_win)
                        end
                        require("omega.colors").init(entry.value)
                    end,
                })
            else
                -- show current buffer content in previewer
                previewer = previewers.new_buffer_previewer({
                    define_preview = function(self, entry)
                        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
                        local filetype = require("plenary.filetype").detect(bufname) or "diff"

                        require("telescope.previewers.utils").highlighter(
                            self.state.bufnr,
                            filetype
                        )
                        require("omega.colors").init(entry.value)
                    end,
                })
            end

            pickers
                .new(opts, {
                    prompt_title = "Colorscheme Picker",
                    results_title = "Colorschemes",
                    -- layout_strategy = "custom_bottom",
                    finder = finders.new_table(opts.data),
                    sorter = conf.generic_sorter(opts),
                    previewer = previewer,
                    attach_mappings = function(_, map)
                        map("i", "<CR>", change_theme)
                        map("n", "<CR>", change_theme)
                        return true
                    end,
                })
                :find()
        end
        local opts = {
            data = utils.get_themes(),
            layout_config = {
                width = 0.99,
                height = 0.5,
                -- anchor = "S",
                preview_cutoff = 20,
                prompt_position = "top",
            },
        }
        base_16_finder(opts)
    end,
    ["buffer_fuzzy"] = function()
        local opts = {
            shorten_path = false,
            prompt_position = "top",
            prompt_title = "Current Buffer",
            preview_title = "Location Preview",
            results_title = "Lines",
            -- layout_strategy = "custom_bottom",
            layout_config = { prompt_position = "top", height = 0.4 },
        }
        require("telescope.builtin").current_buffer_fuzzy_find(opts)
    end,
    ["help_tags"] = function()
        require("lazy").load({ plugins = { "luv-vimdocs" } })
        local builtin = require("telescope.builtin")
        local opts = {
            prompt_title = "Help Tags",
            initial_mode = "insert",
            sorting_strategy = "ascending",
            anchor = "S",
            -- layout_strategy = "custom_bottom",
            layout_config = {
                prompt_position = "top",
                preview_width = 0.75,
                width = 0.95,
                height = 0.8,
                preview_cutoff = 80,
            },
            preview = {
                preview_width = 80,
                hide_on_startup = false,
            },
        }
        builtin.help_tags(opts)
    end,
    ["file_browser"] = function()
        require("telescope").load_extension("file_browser")
        local opts

        opts = {
            sorting_strategy = "ascending",
            -- layout_strategy = "custom_bottom",
            scroll_strategy = "cycle",
            prompt_prefix = "  ",
            layout_config = {
                prompt_position = "top",
            },
        }

        require("telescope").extensions.file_browser.file_browser(opts)
    end,
    ["find_files"] = function()
        local opts = {
            prompt_title = "Find Files",
            preview_title = "File Preview",
            results_title = "Files",
            -- layout_strategy = "custom_bottom",
            find_command = {
                "rg",
                "-g",
                "!.git",
                "--files",
                "--hidden",
                "--no-ignore",
            },
            file_ignore_patterns = {
                "^target",
                "%.aux",
                "%.toc",
                "%.pdf",
                "%.out",
                "%.log",
                "%.png",
                "%.jpg",
                "%.jpeg",
                "%.norg",
            },
            layout_config = {
                prompt_position = "top",
                preview_cutoff = 80,
            },
        }
        require("telescope.builtin").find_files(opts)
    end,
    live_grep = function()
        local builtin = require("telescope.builtin")
        local opts = {
            border = true,
            shorten_path = false,
            prompt_title = "Find String",
            preview_title = "Location Preview",
            -- layout_strategy = "custom_bottom",
            results_title = "Occurrences",
            disable_coordinates = true,
            -- entry_maker = live_grep_entry_maker(),
            layout_config = {
                preview_cutoff = 90,
                width = 0.90,
                height = 0.5,
                prompt_position = "top",
            },
            file_ignore_patterns = {
                "vendor/*",
                "node_modules",
                "%.jpg",
                "%.jpeg",
                "%.png",
                "%.svg",
                "%.otf",
                "%.ttf",
                "%.norg",
            },
            preview = {
                hide_on_startup = false,
            },
        }
        builtin.live_grep(opts)
    end,
}
