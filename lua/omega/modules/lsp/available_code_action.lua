local ca_available = {}

local function place_sign(line, buf)
    vim.fn.sign_place(line, "ca_available", "code_action", buf, { lnum = line + 1 })
end

local function remove_sign()
    vim.fn.sign_unplace("ca_available")
end

local function update_sign(bufnr, client)
    remove_sign()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        return
    end
    local params = vim.lsp.util.make_range_params(0, client.offset_encoding or "utf-8")

    local line = params.range.start.line
    local diags = vim.lsp.diagnostic.from(vim.diagnostic.get(bufnr, { lnum = line }))

    ---@diagnostic disable-next-line: inject-field
    params.context = { diagnostics = diags }
    client:request("textDocument/codeAction", params, function(results)
        if not results or not results[1] then
            return
        end
        ---@diagnostic disable-next-line: undefined-field
        if results[1].error then
            return
        end
        if vim.tbl_isempty(results[1]) then
            return
        end
        if results[1].result and vim.tbl_isempty(results[1].result) then
            return
        end
        place_sign(line, bufnr)
    end, bufnr)
end

function ca_available.setup(bufnr, client)
    local augroup = vim.api.nvim_create_augroup("CodeAction_available", {})
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function(args)
            update_sign(args.buf, client)
        end,
        buffer = bufnr,
        group = augroup,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function()
            remove_sign()
        end,
        buffer = bufnr,
        group = augroup,
    })
    vim.fn.sign_define("code_action", { text = " ", texthl = "CodeActionAvailable", linehl = "", numhl = "" })
end

return ca_available
