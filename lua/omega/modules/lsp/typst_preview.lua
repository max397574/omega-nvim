local M = {}

M.img_id = nil
M.current_page = -1
M.total_pages = 1

local function get_cursor_pos_page(callback)
    local buf_lines = table.concat(vim.api.nvim_buf_get_lines(vim.api.nvim_get_current_buf(), 0, -1, false), "\n")
    local lines = vim.split(buf_lines, "\n", { plain = true })
    local marker = "#context[#metadata(here().page()) <typst_preview_marker>]"
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
    table.insert(lines, cursor_row, marker)
    table.insert(lines, "#context[#metadata(counter(page).final()) <final_page_count>]")
    local line_string = table.concat(lines, "\n")

    local cmd = { "typst", "eval", "query(<typst_preview_marker>).first().value", "--in", "-" }

    vim.system(cmd, { stdin = line_string }, function(obj)
        if obj.code == 0 and obj.stdout and #obj.stdout > 0 then
            local page = tonumber(vim.trim(obj.stdout))
            callback(page)
        else
            vim.system(
                { "typst", "eval", "query(<final_page_count>).first().value", "--in", "-" },
                { stdin = line_string },
                function(obj2)
                    if obj2.code == 0 and obj2.stdout and #obj.stdout > 0 then
                        local total =
                            ---@diagnostic disable-next-line: param-type-mismatch
                            tonumber(vim.trim((obj2.stdout:sub(1, 1) == "[" ? obj2.stdout:sub(2, -2) : obj2.stdout)))
                        M.total_pages = total
                    end
                    callback(math.ceil((cursor_row / #lines) * M.total_pages))
                end
            )
        end
    end)
end

local preview_dir = vim.fn.stdpath("cache") .. "/typst_preview_dir/"
if not vim.uv.fs_stat(preview_dir) then
    vim.uv.fs_mkdir(preview_dir, 493)
end

function M.compile(page_nr, in_path, out_path, callback)
    M.current_page = page_nr
    vim.system(
        { "typst", "compile", "-f", "png", "--ppi", tostring(170), in_path, out_path, "--pages", tostring(page_nr) },
        function(obj)
            if obj.signal ~= 9 and obj.code == 0 then
                vim.schedule(function()
                    callback()
                end)
            else
                print("Compilation failed (see :messages)")
                print(obj.stderr)
                vim.schedule(function()
                    M.clear_preview()
                end)
            end
        end
    )
end

function M.render()
    local preview_path = preview_dir .. vim.fn.expand("%:t:r") .. ".png"
    local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    get_cursor_pos_page(function(page)
        M.compile(page, path, preview_path, function()
            local old_id = M.img_id
            M.img_id = vim.ui.img.set(vim.fn.readblob(preview_path), { col = 92, row = 1, width = 60, zindex = 1000 })
            if old_id then
                vim.ui.img.del(old_id)
            end
        end)
    end)
end

function M.render_offset(n)
    if not M.current_page then
        M.render()
    end
    local preview_path = preview_dir .. vim.fn.expand("%:t:r") .. ".png"
    local path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    M.current_page = M.current_page + n
    M.compile(M.current_page, path, preview_path, function()
        local old_id = M.img_id
        M.img_id = vim.ui.img.set(vim.fn.readblob(preview_path), { col = 92, row = 1, width = 60, zindex = 1000 })
        if old_id then
            vim.ui.img.del(old_id)
        end
    end)
end

function M.previous_page()
    M.render_offset(-1)
end
function M.next_page()
    M.render_offset(1)
end

function M.clear_preview()
    if M.img_id then
        vim.ui.img.del(M.img_id)
    end
    M.img_id = nil
end

return M
