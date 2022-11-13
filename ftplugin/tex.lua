local function latex_clipboard_image()
    local img_dir = vim.fn.getcwd() .. "/images"
    if vim.fn.isdirectory(img_dir) == 0 then
        vim.fn.mkdir(img_dir)
    end
    local index = 1
    local file_path = img_dir .. "/image" .. index .. ".png"
    while vim.fn.filereadable(file_path) ~= 0 do
        index = index + 1
        file_path = img_dir .. "/image" .. index .. ".png"
    end
    local clip_command = 'osascript -e "set png_data to the clipboard as «class PNGf»" -e "set referenceNumber to open for access POSIX path of (POSIX file \\"'
        .. file_path
        .. '\\") with write permission" -e "write png_data to referenceNumber"'
    print(clip_command)
    vim.fn.system(clip_command)
    if vim.v.shell_error == 1 then
        vim.notify("Missing Image in Clipboard", vim.log.levels.ERROR, {})
    else
        local caption = vim.fn.getline(".")
        local cursor = vim.api.nvim_win_get_cursor(0)
        vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], false, {
            "\\begin{figure}[h]",
            "\\includegraphics[width=200px]{image" .. index .. ".png}",
            "\\caption{" .. caption .. "}",
            "\\end{figure}",
        })
    end
end

vim.keymap.set("n", "<c-p>", latex_clipboard_image, { silent = true })
