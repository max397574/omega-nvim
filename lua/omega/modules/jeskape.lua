local jeskape = {
    "Krafi2/jeskape.nvim",
    event = "InsertEnter",
}

jeskape.config = function()
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
end

return jeskape
