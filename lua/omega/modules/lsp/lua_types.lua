return {
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit/library", words = { "vim%.uv" } },
                { path = "luassert/library", words = { "assert" } },
                { path = "busted/library", words = { "describe", "it" } },
                { path = "care.nvim/lua/care/types/" },
            },
        },
    },
    { "LuaCATS/luv", lazy = true },
    { "LuaCATS/busted", lazy = true },
    { "LuaCATS/luassert", lazy = true },
}
