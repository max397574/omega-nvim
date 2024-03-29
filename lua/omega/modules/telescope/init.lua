local telescope = {
    "nvim-telescope/telescope.nvim",
    cmd = { "Telescope" },
}

telescope.dependencies = {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
    },
    { dir = "~/neovim_plugins/lense.nvim" },
}

local function setup_cmd()
    vim.api.nvim_create_user_command("Telescope", function(opts)
        require("telescope.command").load_command(unpack(opts.fargs))
    end, {
        nargs = "*",
        complete = function(_, line)
            local builtin_list = vim.tbl_keys(require("telescope.builtin"))
            local extensions_list = vim.tbl_keys(require("telescope._extensions").manager)

            local l = vim.split(line, "%s+")
            local n = #l - 2

            if n == 0 then
                return vim.tbl_filter(function(val)
                    return vim.startswith(val, l[2])
                end, vim.tbl_extend("force", builtin_list, extensions_list))
            end

            if n == 1 then
                local is_extension = vim.tbl_filter(function(val)
                    return val == l[2]
                end, extensions_list)

                if #is_extension > 0 then
                    local extensions_subcommand_dict =
                        require("telescope.command").get_extensions_subcommand()
                    return vim.tbl_filter(function(val)
                        return vim.startswith(val, l[3])
                    end, extensions_subcommand_dict[l[2]])
                end
            end

            local options_list = vim.tbl_keys(require("telescope.config").values)
            return vim.tbl_filter(function(val)
                return vim.startswith(val, l[#l])
            end, options_list)
        end,
    })
end

telescope.config = function()
    require("omega.modules.telescope.configs")["telescope.nvim"]()
    setup_cmd()
end

telescope.api = require("omega.modules.telescope.api")

return telescope
