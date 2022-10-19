# Ω Omega-nvim

This is my new neovim config after [ignis-nvim](https://github.com/max397574/ignis-nvim).

![Screenshot 2022-05-18 at 21 30 16](https://user-images.githubusercontent.com/81827001/169141006-12601439-a19a-4305-95b4-5ac1650f7473.png)

## Why a new configuration?

I wanted to do some big refactors.
The biggest change was that I wanted to split up my plugins into modules and not keep them in one single file (not the configurations but the tables I pass into packers `use`).
I've done this here now and in the process optimized many things.

## Information
At the time of writing this the configuration has 55 plugins.
*4 out of those 55 plugins are loaded at startup.*
This allows me to get a really low startup time (4 times less than ignis).

### Some lazyloading goodies
Here are some plugins which don't have a obvious way of lazyloading them but I still managed to lazyload.

#### Telescope-ui-select
```lua
{
    "nvim-telescope/telescope-ui-select.nvim",
    opt = true,
    setup = function()
        vim.ui.select = function(items, opts, on_choice)
            vim.cmd([[
                PackerLoad telescope.nvim
                PackerLoad telescope-ui-select.nvim
            ]])
            require("telescope").load_extension("ui-select")
            vim.ui.select(items, opts, on_choice)
        end
    end,
}
```

#### Gitsigns.nvim
```lua
{
    "lewis6991/gitsigns.nvim",
    opt = true,
    setup = function()
        vim.api.nvim_create_autocmd({ "BufAdd", "VimEnter" }, {
            callback = function()
                local function onexit(code, _)
                    if code == 0 then
                        vim.schedule(function()
                            require("packer").loader("gitsigns.nvim")
                        end)
                    end
                end
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                if lines ~= { "" } then
                    vim.loop.spawn("git", {
                        args = {
                            "ls-files",
                            "--error-unmatch",
                            vim.fn.expand("%"),
                        },
                    }, onexit)
                end
            end,
        })
    end,
}
```

## The structure

The structure is inspired by doom-nvim.

### Core folder
I have a `core` folder in which files for things like autocommands, commands, setting or utils are.
Inside this folder there is an `init.lua` file.
Here is where everything is coordinated.
From here an `omega` global variable gets created in which the plugins get loaded.
From there they get loaded with packer.

### Modules folder
In this folder there are folders for modules e.g. completion, lsp or tools.
Inside those there are files for single or multiple plugins.
Those files are required to get the plugin specs for packer and the configurations.

### Colors folder
Inside this folders there are files which are used to define highlights.
This is done like nvchad did in the past (before they changed it to base46).
