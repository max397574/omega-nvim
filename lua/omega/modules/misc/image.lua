local image = {}

image.plugins = {
    ["image.nvim"] = {
        "samodostal/image.nvim",
        setup = function()
            vim.api.nvim_create_autocmd({ "BufEnter", "VimResized" }, {
                pattern = {
                    "*.jpeg",
                    "*.jpg",
                    "*.png",
                    "*.bmp",
                    "*.webp",
                    "*.tiff",
                    "*.tif",
                },
                once = true,
                callback = function()
                    require("packer").loader("image.nvim")
                    vim.cmd.PackerLoad("baleia.nvim")
                    require("image").setup({
                        render = {
                            foreground_color = true,
                            background_color = true,
                        },
                    })
                    local async = require("plenary.async")
                    local config = require("image.config")
                    local ui = require("image.ui")
                    local dimensions = require("image.dimensions")
                    local api = require("image.api")
                    local options = require("image.options")
                    local global_opts = nil
                    local on_image_open = function()
                        local buf_id = 0
                        local buf_path = vim.api.nvim_buf_get_name(buf_id)

                        local ascii_width, ascii_height, horizontal_padding, vertical_padding =
                            dimensions.calculate_ascii_width_height(buf_id, buf_path, global_opts)

                        options.set_options_before_render(buf_id)
                        ui.buf_clear(buf_id)

                        local label = ui.create_label(buf_path, ascii_width, horizontal_padding)

                        local ascii_data =
                            api.get_ascii_data(buf_path, ascii_width, ascii_height, global_opts)
                        ui.buf_insert_data_with_padding(
                            buf_id,
                            ascii_data,
                            horizontal_padding,
                            vertical_padding,
                            label,
                            global_opts
                        )

                        options.set_options_after_render(buf_id)
                    end
                    global_opts = config.DEFAULT_OPTS

                    async.run(on_image_open, function() end)
                end,
            })
        end,
        opt = true,
    },
    ["baleia.nvim"] = {
        "m00qek/baleia.nvim",
        opt = true,
    },
}

return image
