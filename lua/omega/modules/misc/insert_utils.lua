local insert_utils = {}

insert_utils.configs = {
    ["jeskape.nvim"] = function()
        require("jeskape").setup({
            mappings = {
                [","] = {
                    [","] = "<cmd>lua require'omega.utils'.append_comma()<CR>",
                },
                [";"] = {
                    [";"] = "<cmd>lua require'omega.utils'.append_semicolon()<CR>",
                },
                j = {
                    k = "<esc>",
                    [","] = "<cmd>lua require'omega.utils'.append_comma()<CR><esc>o",
                    j = "<esc>A<cr>",
                },
            },
        })
    end,
}

return insert_utils
