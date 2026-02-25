return {
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit/library", words = { "vim%.uv" } },
                { path = "luassert/library", words = { "assert" } },
                { path = "busted/library", words = { "describe", "it" } },
                { path = "care.nvim/lua/care/types/" },
                { path = "~/.hammerspoon/Spoons/EmmyLua.spoon/annotations" },
            },
        },
    },
    { "LuaCATS/luv", lazy = true },
    { "LuaCATS/busted", lazy = true },
    { "LuaCATS/luassert", lazy = true },
}
