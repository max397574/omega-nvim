return {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = { "html", "css" },
    root_dir = vim.fs.root(0, { "package.json", ".git" }),
    autostart = true,
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
}
