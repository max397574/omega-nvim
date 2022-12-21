local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local config=require"omega.config".values

local configs = {
    ["telescope.nvim"] = function()
        -- vim.defer_fn(function()
        --     vim.cmd.PackerLoad("neorg")
        -- end, 1)
        require("lazy").load("lense.nvim")
        --- Pick any picker and use `cwd` as `cwd`
        ---@param cwd string The `cwd` to use
        local function pick_pickers(cwd)
            local opts = {}
            if not cwd then
                return
            end
            print(cwd)
            opts.include_extensions = true

            local objs = {}

            for k, v in pairs(require("telescope.builtin")) do
                local debug_info = debug.getinfo(v)
                table.insert(objs, {
                    filename = string.sub(debug_info.source, 2),
                    text = k,
                })
            end

            local title = "Telescope Builtin"

            if opts.include_extensions then
                title = "Telescope Pickers"
                for ext, funcs in pairs(require("telescope").extensions) do
                    for func_name, func_obj in pairs(funcs) do
                        -- Only include exported functions whose name doesn't begin with an underscore
                        if type(func_obj) == "function" and string.sub(func_name, 0, 1) ~= "_" then
                            local debug_info = debug.getinfo(func_obj)
                            table.insert(objs, {
                                filename = string.sub(debug_info.source, 2),
                                text = string.format("%s : %s", ext, func_name),
                            })
                        end
                    end
                end
            end

            pickers
                .new(opts, {
                    prompt_title = title,
                    finder = finders.new_table({
                        results = objs,
                        entry_maker = function(entry)
                            return {
                                value = entry,
                                text = entry.text,
                                display = entry.text,
                                ordinal = entry.text,
                                filename = entry.filename,
                            }
                        end,
                    }),
                    previewer = previewers.builtin.new(opts),
                    sorter = conf.generic_sorter(opts),
                    attach_mappings = function(_)
                        actions.select_default:replace(function(_)
                            local selection = action_state.get_selected_entry()
                            if not selection then
                                print("[telescope] Nothing currently selected")
                                return
                            end

                            -- we do this to avoid any surprises
                            opts.include_extensions = nil
                            opts.cwd = cwd

                            if string.match(selection.text, " : ") then
                                -- Call appropriate function from extensions
                                local split_string = vim.split(selection.text, " : ")
                                local ext = split_string[1]
                                local func = split_string[2]
                                require("telescope").extensions[ext][func](opts)
                            else
                                -- Call appropriate telescope builtin
                                require("telescope.builtin")[selection.text](opts)
                            end
                        end)
                        return true
                    end,
                })
                :find()
        end

        local picker_selection_as_cwd = function(prompt_bufnr)
            local get_target_dir = function(finder)
                local entry_path
                local entry = action_state.get_selected_entry()
                if finder.files == false then
                    entry_path = entry and entry.value -- absolute path
                end
                return finder.files and finder.path or entry_path
            end
            local current_picker = action_state.get_current_picker(prompt_bufnr)
            local finder = current_picker.finder

            local dir = get_target_dir(finder)
            actions.close(prompt_bufnr)
            pick_pickers(dir)
        end

        require"lazy".load("telescope-fzf-native.nvim")
        local action_layout = require("telescope.actions.layout")
        local actions_layout = require("telescope.actions.layout")
        -- local fb_actions = require("telescope._extensions.file_browser.actions")
        local themes = require("telescope.themes")
        local resolve = require("telescope.config.resolve")
        local p_window = require("telescope.pickers.window")
        local if_nil = vim.F.if_nil

        local calc_tabline = function(max_lines)
            local tbln = (vim.o.showtabline == 2)
                or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
            if tbln then
                max_lines = max_lines - 1
            end
            return max_lines, tbln
        end

        local get_border_size = function(opts)
            if opts.window.border == false then
                return 0
            end

            return 1
        end

        local calc_size_and_spacing = function(cur_size, max_size, bs, w_num, b_num, s_num)
            local spacing = s_num * (1 - bs) + b_num * bs
            cur_size = math.min(cur_size, max_size)
            cur_size = math.max(cur_size, w_num + spacing)
            return cur_size, spacing
        end

        require("telescope.pickers.layout_strategies").custom_bottom =
            function(self, max_columns, max_lines, layout_config)
                local initial_options = p_window.get_initial_window_options(self)
                local results = initial_options.results
                local prompt = initial_options.prompt
                local preview = initial_options.preview
                layout_config = {
                    anchor = "S",
                    -- preview_width = 0.6,
                    bottom_pane = {
                        height = 0.5,
                        preview_cutoff = 70,
                        prompt_position = "top",
                    },
                    custom_bottom = {
                        height = 0.5,
                        preview_cutoff = 70,
                        -- preview_width = 0.6,
                        prompt_position = "top",
                    },
                    center = {
                        height = 0.5,
                        preview_cutoff = 70,
                        prompt_position = "top",
                        width = 0.99,
                    },
                    cursor = {
                        height = 0.5,
                        preview_cutoff = 70,
                        width = 0.99,
                    },
                    flex = {
                        horizontal = {},
                        preview_cutoff = 70,
                        preview_width = 0.65,
                    },
                    height = 0.5,
                    horizontal = {
                        height = 0.5,
                        preview_cutoff = 70,
                        preview_width = 0.65,
                        prompt_position = "top",
                        width = 0.99,
                    },
                    preview_cutoff = 70,
                    prompt_position = "top",
                    vertical = {
                        height = 0.95,
                        preview_cutoff = 70,
                        preview_height = 0.5,
                        preview_width = 0.65,
                        prompt_position = "top",
                        width = 0.9,
                    },
                    width = 0.99,
                }

                local tbln
                max_lines, tbln = calc_tabline(max_lines)

                local height = if_nil(
                    resolve.resolve_height(layout_config.height)(self, max_columns, max_lines),
                    25
                )
                local width_opt = layout_config.width

                local width = resolve.resolve_width(width_opt)(self, max_columns, max_lines)

                -- local height = 21
                if
                    type(layout_config.height) == "table"
                    and type(layout_config.height.padding) == "number"
                then
                    height = math.floor((max_lines + height) / 2)
                end
                prompt.border = results.border

                local bs = get_border_size(self)

                -- Cap over/undersized height
                height, _ = calc_size_and_spacing(height, max_lines, bs, 2, 3, 0)

                -- Height
                prompt.height = 2
                results.height = height - prompt.height - (2 * bs)
                preview.height = results.height - bs

                -- Width
                local w_space

                preview.width = 0
                prompt.width = max_columns - 2 * bs
                if self.previewer and max_columns >= layout_config.preview_cutoff then
                    -- Cap over/undersized width (with preview)
                    width, w_space = calc_size_and_spacing(max_columns, max_columns, bs, 2, 4, 0)

                    preview.width = resolve.resolve_width(if_nil(layout_config.preview_width, 0.6))(
                        self,
                        width,
                        max_lines
                    )
                    results.width = width - preview.width - w_space
                    prompt.width = results.width
                    results.width = results.width
                else
                    width, w_space = calc_size_and_spacing(width, max_columns, bs, 1, 2, 0)
                    preview.width = 0
                    results.width = width - preview.width - w_space
                    prompt.width = results.width
                end

                -- Line
                if layout_config.prompt_position == "top" then
                    prompt.line = max_lines - results.height - (1 + bs) + 1
                    results.line = prompt.line + 1
                    preview.line = prompt.line + 1
                    if results.border == true then
                        results.border = { 0, 1, 1, 1 }
                    end
                    if type(results.title) == "string" then
                        results.title = { { pos = "S", text = results.title } }
                    end
                elseif layout_config.prompt_position == "bottom" then
                    results.line = max_lines - results.height - (1 + bs) + 1
                    results.line = prompt.line + 1
                    preview.line = results.line
                    prompt.line = max_lines - bs
                    if type(prompt.title) == "string" then
                        prompt.title = { { pos = "S", text = prompt.title } }
                    end
                    if results.border == true then
                        results.border = { 1, 1, 0, 1 }
                    end
                else
                    error(
                        "Unknown prompt_position: "
                            .. tostring(self.window.prompt_position)
                            .. "\n"
                            .. vim.inspect(layout_config)
                    )
                end
                local width_padding = math.floor((max_columns - width) / 2)

                -- Col
                prompt.col = 0 -- centered
                if layout_config.mirror and preview.width > 0 then
                    results.col = preview.width + (3 * bs)
                    preview.col = bs + 1
                    prompt.col = results.col
                else
                    preview.col = prompt.width + width_padding + bs + 1

                    results.col = bs + 1
                    prompt.col = preview.col + preview.width + bs
                end

                if tbln then
                    -- prompt.line = prompt.line + 1
                    results.line = results.line + 1
                    preview.line = preview.line
                    prompt.line = prompt.line
                else
                    results.line = results.line + 1
                end
                prompt.line = prompt.line + 1
                results.line = results.line + 1
                preview.col = preview.col + 1
                preview.height = preview.height - 2
                prompt.col = 2
                results.height = results.height - 1
                preview.height = prompt.height + results.height
                results.col = 2

                return {
                    preview = self.previewer and preview.width > 0 and preview,
                    prompt = prompt,
                    results = results,
                }
            end
        local _bad = { ".*%.md" } -- Put all filetypes that slow you down in this array
        local bad_files = function(filepath)
            for _, v in ipairs(_bad) do
                if filepath:match(v) then
                    return false
                end
            end

            return true
        end

        local new_maker = function(filepath, bufnr, opts)
            opts = opts or {}
            if opts.use_ft_detect == nil then
                opts.use_ft_detect = true
            end
            opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
        if config.telescope_theme == "custom_bottom_no_borders" then
            require("telescope").setup(themes.get_ivy({
                -- defaults = themes.get_ivy({
                defaults = {
                    buffer_previewer_maker = new_maker,
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    layout_strategy = "custom_bottom",
                    sorting_strategy = "ascending",
                    prompt_prefix = "   ",
                    selection_caret = "  ",
                    get_status_text = function(_)
                        return ""
                    end,
                    path_display = { "smart", "shorten" },
                    layout_config = {
                        width = 0.85,
                        height = 0.9,
                        preview_cutoff = 70,
                        prompt_position = "top",
                        vertical = { mirror = false },
                        horizontal = {
                            mirror = false,
                            preview_width = 0.6,
                        },
                    },
                    mappings = {
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-s>"] = require("lense.actions").live_grep_selected,
                            ["<C-o>"] = actions.select_vertical,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<C-h>"] = "which_key",
                            ["<C-l>"] = actions_layout.toggle_preview,
                            -- ["<C-y>"] = set_prompt_to_entry_value,
                            ["<C-d>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-u>"] = require("telescope.actions").cycle_history_prev,
                            ["<a-cr>"] = picker_selection_as_cwd,
                        },
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<c-p>"] = action_layout.toggle_prompt_position,
                            ["<C-k>"] = actions.move_selection_previous,
                            -- ["<C-y>"] = set_prompt_to_entry_value,
                            ["<C-o>"] = actions.select_vertical,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<C-h>"] = "which_key",
                            ["<C-l>"] = actions_layout.toggle_preview,
                            ["<C-d>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-s>"] = require("lense.actions").live_grep_selected,
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-u>"] = require("telescope.actions").cycle_history_prev,
                            ["<a-cr>"] = picker_selection_as_cwd,
                        },
                    },
                    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            width = 0.3,
                            height = 0.7,
                        }),
                    },
                    ["file_browser"] = {
                        -- theme = "ivy",
                        mappings = {
                            ["i"] = {
                                ["<C-o>"] = actions.select_vertical,
                                -- ["<C-b>"] = fb_actions.toggle_browser,
                            },
                            ["n"] = {},
                        },
                    },
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    },
                },
            }))
        elseif config.telescope_theme == "float_all_borders" then
            require("telescope").setup({
                -- defaults = themes.get_ivy({
                defaults = {
                    buffer_previewer_maker = new_maker,
                    initial_mode = "insert",
                    selection_strategy = "reset",
                    sorting_strategy = "ascending",
                    layout_strategy = "horizontal",
                    prompt_prefix = "   ",
                    selection_caret = "  ",
                    get_status_text = function(_)
                        return ""
                    end,
                    path_display = { "smart", "shorten" },
                    layout_config = {
                        width = 0.85,
                        height = 0.9,
                        preview_cutoff = 70,
                        prompt_position = "top",
                        vertical = { mirror = false },
                        horizontal = {
                            mirror = false,
                            preview_width = 0.6,
                        },
                    },
                    mappings = {
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-s>"] = require("lense.actions").live_grep_selected,
                            ["<C-o>"] = actions.select_vertical,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<C-h>"] = "which_key",
                            ["<C-l>"] = actions_layout.toggle_preview,
                            -- ["<C-y>"] = set_prompt_to_entry_value,
                            ["<C-d>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-u>"] = require("telescope.actions").cycle_history_prev,
                            ["<a-cr>"] = picker_selection_as_cwd,
                        },
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<c-p>"] = action_layout.toggle_prompt_position,
                            ["<C-k>"] = actions.move_selection_previous,
                            -- ["<C-y>"] = set_prompt_to_entry_value,
                            ["<C-o>"] = actions.select_vertical,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-a>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<C-h>"] = "which_key",
                            ["<C-l>"] = actions_layout.toggle_preview,
                            ["<C-d>"] = actions.preview_scrolling_up,
                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-s>"] = require("lense.actions").live_grep_selected,
                            ["<C-n>"] = require("telescope.actions").cycle_history_next,
                            ["<C-u>"] = require("telescope.actions").cycle_history_prev,
                            ["<a-cr>"] = picker_selection_as_cwd,
                        },
                    },
                    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({
                            width = 0.3,
                            height = 0.7,
                        }),
                    },
                    ["file_browser"] = {
                        -- theme = "ivy",
                        mappings = {
                            ["i"] = {
                                ["<C-o>"] = actions.select_vertical,
                                -- ["<C-b>"] = fb_actions.toggle_browser,
                            },
                            ["n"] = {},
                        },
                    },
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    },
                },
            })
        end
        require("telescope").load_extension("fzf")
        -- require("telescope").load_extension("ui-select")
    end,
    ["telescope-emoji.nvim"] = function()
        require("telescope").load_extension("emoji")
    end,
}
return configs
