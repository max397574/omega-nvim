local config = {}

config.values = {
    use_impatient = true,
    -- "round_colored_bg"|"round_dark_bg"|"round_blended"
    statusline = "round_blended",
    colorscheme = "onedark",
    light_colorscheme = "everforest",
    --- string "float_all_borders"|"custom_bottom_no_borders"
    telescope_theme = "float_all_borders",
    --- string "float_all_borders"|"custom_bottom_no_borders"
    telescope_highlights = "custom_bottom_no_borders",
    --- String "border"|"no-border"
    cmp_theme = "no-border",
    lsp_definition_context = 10,
    --- "normal"|"top"|"bottom"
    noice_cmdline_position = "normal",
}

return config
