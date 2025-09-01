return {
    name = "ts_ls",
    cmd = { "typescript-language-server", "--stdio" },
    root_dir = vim.fs.root(0, { "package.json", ".git" }),
    autostart = true,
    init_options = { hostInfo = "neovim" },
    single_file_support = true,
    log_level = vim.lsp.protocol.MessageType.Warning,
}
