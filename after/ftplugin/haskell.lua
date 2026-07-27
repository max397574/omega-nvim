local ok, ht = pcall(require, "haskell-tools")
if not ok then
    return
end
local bufnr = vim.api.nvim_get_current_buf()
local opts = { remap = false, silent = true, buffer = bufnr }
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, opts)
-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set("n", "<leader>hs", ht.hoogle.hoogle_signature, opts)
-- Evaluate all code snippets
vim.keymap.set("n", "<leader>ea", ht.lsp.buf_eval_all, opts)
-- Toggle a GHCi repl for the current package
vim.keymap.set("n", "<leader>rr", ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set("n", "<leader>rf", function()
    ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, opts)
vim.keymap.set("n", "<leader>rl", || -> ht.repl.reload(), opts)
vim.keymap.set("n", "<leader>rq", ht.repl.quit, opts)

vim.bo[bufnr].shiftwidth = 2

local function run_in_split()
    vim.cmd("botright split")
    vim.cmd("terminal ghci " .. vim.fn.expand("%"))
    vim.cmd.startinsert()
    vim.keymap.set("n", "q", function()
        vim.cmd.bd()
    end, { buffer = true })
end

vim.keymap.set("n", "<localleader>r", || -> run_in_split(), opts)
