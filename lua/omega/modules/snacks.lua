---@diagnostic disable assign-type-mismatch

local config = require("omega.config")
local snacks = {
    "snacks.nvim",
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
    },
    statuscolumn = {
        folds = {
            open = true,
        },
    },
}


-- stylua: ignore
snacks.keys = {
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find file", },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Live Grep", },
    { "<leader>hh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
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

return snacks
