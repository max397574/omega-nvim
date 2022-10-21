local lsp_definitions = {}
require("plenary.reload").reload_module("omega.modules.lsp")
local ns = vim.api.nvim_create_namespace("lsp-definition")
local extmarks = {}

local function add_virtual_text(contents)
    local cursor = vim.api.nvim_win_get_cursor(0)
    if not contents then
        return
    end
    local highlight_lines = {}
    for _, line in ipairs(contents) do
        table.insert(highlight_lines, { { line, "Definition" } })
    end
    extmarks[contents[1]] = vim.api.nvim_buf_set_extmark(
        0,
        ns,
        cursor[1] - 1,
        0,
        { virt_lines = highlight_lines, virt_lines_above = true }
    )
end

local function toggle_virtual_text(contents)
    local cursor = vim.api.nvim_win_get_cursor(0)
    if not contents then
        return
    end

    if extmarks[contents[1]] then
        vim.api.nvim_buf_del_extmark(0, ns, extmarks[contents[1]])
        extmarks[contents[1]] = nil
    else
        local highlight_lines = {}
        for _, line in ipairs(contents) do
            table.insert(highlight_lines, { { line, "Definition" } })
        end
        if next(contents) == nil then
            vim.notify("peek: Unable to get contents of the file!", vim.log.levels.WARN)
            return
        end
        extmarks[contents[1]] = vim.api.nvim_buf_set_extmark(
            0,
            ns,
            cursor[1],
            0,
            { virt_lines = highlight_lines, virt_lines_above = true }
        )
    end
end

local winnr = nil
local function open_floating_buffer(contents, bufnr)
    if winnr then
        vim.api.nvim_clear_autocmds({ group = "lsp-definition-float" })
        vim.api.nvim_set_current_win(winnr)
        return
    end
    winnr = vim.api.nvim_open_win(bufnr, false, {
        relative = "cursor",
        width = 100,
        height = #contents,
        col = 0,
        row = 1,
        border = "rounded",
        style = "minimal",
    })
    -- TODO: set cursor
    vim.wo[winnr].winbar = nil
    vim.api.nvim_create_autocmd("WinClosed", {
        callback = function()
            winnr = nil
        end,
        pattern = tostring(winnr),
    })
    vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        callback = function()
            vim.api.nvim_win_close(winnr, false)
            winnr = nil
        end,
        group = vim.api.nvim_create_augroup("lsp-definition-float", {}),
        buffer = 0,
        once = true,
    })
end

local actions = {
    ["toggle_virtual_text"] = function(contents)
        toggle_virtual_text(contents)
    end,
    ["add_virtual_text"] = function(contents)
        add_virtual_text(contents)
    end,
    ["open_floating_buffer"] = function(contents, _, bufnr)
        open_floating_buffer(contents, bufnr)
    end,
}

function lsp_definitions.get_definition(action)
    local context = omega.config.lsp_definition_context
    local position_params = vim.lsp.util.make_position_params(0)
    vim.lsp.buf_request(0, "textDocument/definition", position_params, function(err, result, ...)
        local location = vim.tbl_islist(result) and result[1] or result
        -- vim.lsp.handlers["textDocument/definition"](err, result, ...)

        if not result then
            return
        end
        local uri = location.targetUri or location.uri
        if uri == nil then
            return
        end
        local bufnr = vim.uri_to_bufnr(uri)
        if not vim.api.nvim_buf_is_loaded(bufnr) then
            vim.fn.bufload(bufnr)
        end

        local range = location.targetRange or location.range

        local contents = vim.api.nvim_buf_get_lines(
            bufnr,
            range.start.line,
            math.min(range["end"].line + 1 + context, range.start.line + 15),
            false
        )
        if next(contents) == nil then
            vim.notify("Unable to get contents of file", vim.log.levels.WARN)
            return
        end
        actions[action](contents, range, bufnr)
    end)
end

return lsp_definitions
