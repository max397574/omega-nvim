return {
    ui = {
        colorscheme = "onedark",
        tabline = {
            ---@type "padding"|"thin"
            separator_style = "padding",
            ---@type number
            max_width = 15,
        },
        statusline = {
            ---@type boolean
            use_dev_icons = false,
            ---@type "round"|"angled"
            separator_style = "round",
            ---@type "blended"|"colored_bg"|"dark_bg"
            color = "blended",
            components = {
                lsp = {
                    spinner = {
                        "⠋",
                        "⠙",
                        "⠹",
                        "⠸",
                        "⠼",
                        "⠴",
                        "⠦",
                        "⠧",
                        "⠇",
                        "⠏",
                    },
                },
            },
        },
        cmp = {
            --- What type of border to add
            ---@type "half"|"none"|"rounded"
            border = "half",
            --- How the icons should look
            ---@type "blended"|"fg_colored"
            icons = "blended",
            ---@type ("source"|"kind_icon"|"type"|"text")[]
            fields = {
                "kind_icon",
                "text",
                "type",
            },
        },
        telescope = {
            --- Whether to show borders or not
            ---@type boolean
            borders = false,
            --- How to highlight the titles
            ---@type "blocks"|"no_bg"
            titles = "blocks",
        },
    },
    modules = {
        ---@type "telescope"|"fzf"
        picker = "telescope",
        ---@type "neocomplete"|"cmp"
        completion = "neocomplete",
    },
}
