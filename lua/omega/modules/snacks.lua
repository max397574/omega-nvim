---@diagnostic disable assign-type-mismatch

local config = require("omega.config")
local snacks = {
    "snacks.nvim",
    -- dev = true,
}

---@type snacks.Config
snacks.opts = {
    input = { enabled = false },
    indent = {
        enabled = true,
        chunk = { enabled = false },
        filter = function(buf)
            local disabled_filetypes = { "typst" }
            return vim.g.snacks_indent ~= false
                and vim.b[buf].snacks_indent ~= false
                and vim.bo[buf].buftype == ""
                and not vim.tbl_contains(disabled_filetypes, vim.bo[buf].filetype)
        end,
    },
    picker = {
        prompt = "  ",
        win = {
            input = {
                keys = {
                    ["<c-d>"] = { "preview_scroll_up", mode = { "i", "n" } },
                    ["<c-s>"] = { "grep_selected", mode = { "i", "n" } },
                },
            },
        },
        actions = {
            grep_selected = function(picker)
                local selected = vim.iter(picker:selected({ fallback = true }))
                    :map(function(entry)
                        return "/" .. entry.file
                    end)
                    :totable()
                vim.schedule(function()
                    Snacks.picker.grep({ glob = selected })
                end)
            end,
            add_file = function(picker)
                Snacks.input.disable()
                local Tree = require("snacks.explorer.tree")
                vim.ui.input({
                    prompt = 'Add a new file or directory (directories end with a "/")> ',
                }, function(value)
                    local uv = vim.uv
                    if not value or value:find("^%s$") then
                        return
                    end
                    local path = svim.fs.normalize(picker:dir() .. "/" .. value)
                    local is_file = value:sub(-1) ~= "/"
                    local dir = is_file and vim.fs.dirname(path) or path
                    if is_file and uv.fs_stat(path) then
                        Snacks.notify.warn("File already exists:\n- `" .. path .. "`")
                        return
                    end
                    vim.fn.mkdir(dir, "p")
                    if is_file then
                        io.open(path, "w"):close()
                    end
                    Tree:open(dir)
                    Tree:refresh(dir)
                    require("snacks.explorer.actions").update(picker, { target = path })
                end)
            end,
        },
        image = { enabled = false },
        sources = {
            explorer = {
                layout = {
                    preview = "main",
                    layout = {
                        backdrop = false,
                        width = 40,
                        min_width = 40,
                        height = 0,
                        position = "left",
                        border = "right",
                        box = "vertical",
                        {
                            win = "input",
                            height = 1,
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                        },
                        { win = "list", border = "none", wo = { signcolumn = "yes:1" } },
                        { win = "preview", title = "{preview}", height = 0.4, border = "top" },
                    },
                },
                win = {
                    list = {
                        keys = {
                            ["a"] = "add_file",
                        },
                    },
                },
            },
        },
    },
    explorer = {},
    statuscolumn = {
        folds = {
            open = true,
        },
    },
}


-- stylua: ignore
snacks.keys = {
    { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart open", },

    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find file", },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Live Grep", },
    { "<leader>.", function() Snacks.explorer.open({ layout = { preset = "sidebar" } }) end, desc = "File Browser", },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "File Browser", },
    { "<leader>hh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<c-s>", function() Snacks.picker.lines() end, desc = "Current buffer fuzzy find" },

    -- Search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
    { "<leader>sp", function() Snacks.picker() end, desc = "Pickers" },
    {
        "<leader>sf",
        function()
            local Snacks = require("snacks")
            Snacks.picker({
                finder = "proc",
                cmd = "fd",
                args = { "--type", "d", "--exclude", ".git" },
                title = "Select search directory",
                layout = {
                    preset = "select",
                },
                actions = {
                    confirm = function(picker, item)
                        picker:close()
                        vim.schedule(function()
                            Snacks.picker.files({ cwd = item.file })
                        end)
                    end,
                },
                transform = function(item)
                  item.file = item.text
                  item.dir = true
                end,
            })
        end,
        desc = "Search in dir",
    },
}

-- stylua: ignore
table.insert(snacks.keys, { "<leader>Ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" })

---@param opts snacks.Config
function snacks.config(_, opts)
    Snacks.toggle.profiler():map("<leader>Pp")
    Snacks.toggle.profiler_highlights():map("<leader>Ph")

    if config.ui.picker.borders == "half_block_to_edge" or config.ui.picker.borders == "up_to_edge" then
        opts.picker.layout = {
            cycle = true,
            layout = {
                -- backdrop = false,
                box = "horizontal",
                dim = false,
                width = 0.8,
                min_width = 120,
                height = 0.8,
                {
                    box = "vertical",
                    border = (config.ui.picker.borders == "half_block_to_edge" and {
                        "🬕",
                        "🬂",
                        { "▌", "SnacksPickerBorderCenter" },
                        { "▌", "SnacksPickerBorderCenter" },
                        { "▌", "SnacksPickerBorderCenter" },
                        "🬭",
                        "🬲",
                        "▌",
                    } or {
                        { "🮈", "SnacksPickerBorderCenter" },
                        "▔",
                        { "▍", "SnacksPickerBorderCenter" },
                        { "▍", "SnacksPickerBorderCenter" },
                        { "▍", "SnacksPickerBorderCenter" },
                        "▁",
                        { "🮈", "SnacksPickerBorderCenter" },
                        { "🮈", "SnacksPickerBorderCenter" },
                    }),
                    -- title = "{title} {live} {flags}",
                    title = { { " {title} {live} {flags}", "SnacksPickerBoxTitle" } },
                    { win = "input", height = 1, border = { "", "", "", "", "", "─", " ", "" } },
                    { win = "list", border = "none" },
                },
                {
                    win = "preview",
                    -- title = "{preview}",
                    title = { { "󰈔 {preview} ", "SnacksPickerPreviewTitle" } },
                    wo = {
                        relativenumber = false,
                        signcolumn = "no",
                        statuscolumn = "",
                    },
                    border = (config.ui.picker.borders == "half_block_to_edge" and {
                        { "▐", "SnacksPickerBorderCenter" },
                        "🬂",
                        "🬨",
                        "▐",
                        "🬷",
                        "🬭",
                        { "▐", "SnacksPickerBorderCenter" },
                        { "▐", "SnacksPickerBorderCenter" },
                    } or {
                        { "🮈", "SnacksPickerBorderCenter" },
                        "▔",
                        { "▍", "SnacksPickerBorderCenter" },
                        { "▍", "SnacksPickerBorderCenter" },
                        { "▍", "SnacksPickerBorderCenter" },
                        "▁",
                        { "🮈", "SnacksPickerBorderCenter" },
                        { "🮈", "SnacksPickerBorderCenter" },
                    }),

                    width = 0.5,
                },
            },
        }
    end
    require("snacks").setup(opts)
end

return snacks
