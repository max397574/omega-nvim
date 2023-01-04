vim.bo.shiftwidth = 2
vim.o.conceallevel = 2
vim.bo.commentstring = "#%s"
vim.wo.spell = true
vim.bo.spelllang = "en"

local wk = require("which-key")

wk.register({
    t = {
        name = "+Tasks",
        d = { "Done" },
        u = { "Undone" },
        p = { "Pending" },
        i = { "Important" },
        h = { "On Hold" },
        c = { "Cancelled" },
        r = { "Recurring" },
    },
}, {
    prefix = "g",
    mode = "n",
})

wk.register({
    m = {
        name = "+Mode",
        n = "Norg",
        h = "Traverse Heading",
    },
    t = {
        name = "+Gtd",
        c = "Capture",
        e = "Edit",
        v = "Views",
    },
    p = {
        name = "+Pick",
        a = {
            name = "+AOF",
            p = {
                "<cmd>Telescope neorg find_aof_project_tasks<cr>",
                "Project Tasks",
            },
            t = { "<cmd>Telescope neorg find_aof_tasks<cr>", "Tasks" },
        },
        c = { "<cmd>Telescope neorg find_context_tasks<cr>", "Context Tasks" },
        p = { "<cmd>Telescope neorg find_project_tasks<cr>", "Project Tasks" },
    },
    n = {
        name = "+New Note",
        n = "New Note",
    },
    l = { "<cmd>Telescope neorg insert_link<CR>", "Insert Link" },
}, {
    prefix = ",",
    mode = "n",
})

require("omega.modules.surround").config()
require("nvim-surround").buffer_setup({
    surrounds = {
        ["/"] = { add = { "/", "/" } },
        ["*"] = { add = { "*", "*" } },
        ["_"] = { add = { "_", "_" } },
        ["-"] = { add = { "-", "-" } },
    },
    highlight = {
        duration = 300,
    },
    move_cursor = false,
})
