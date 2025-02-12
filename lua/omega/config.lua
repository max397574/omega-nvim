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
        completion = {
            --- What type of border to add
            ---@type "half"|"none"|"rounded"|"up_to_edge"
            border = "up_to_edge",
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
        picker = {
            --- How to show border
            ---@type "blocks"|"none"|"normal"|"half_block"|"half_block_to_edge"|"up_to_edge"
            borders = "up_to_edge",
            --- How to highlight the titles
            ---@type "blocks"|"no_bg"
            titles = "blocks",
        },
    },
    modules = {
        ---@type "telescope"|"fzf"|"snacks"
        picker = "snacks",
        ---@type "care"|"cmp"|"blink"|"none"
        completion = "care",
    },
}
