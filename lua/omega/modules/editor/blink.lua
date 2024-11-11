local blink = {
    "saghen/blink.cmp",
    enabled = require("omega.config").modules.completion == "blink",
    lazy = false,
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
}

function blink.config()
    local border
    local border_config = require("omega.config").ui.completion.border
    if border_config == "half" then
        border = {
            -- { "▄", "@care.border" },
            -- { "▄", "@care.border" },
            -- { "▄", "@care.border" },
            -- { "█", "@care.border" },
            -- { "▀", "@care.border" },
            -- { "▀", "@care.border" },
            -- { "▀", "@care.border" },
            -- { "█", "@care.border" },
            { "▗", "@care.border" },
            { "▄", "@care.border" },
            { "▖", "@care.border" },
            { "▌", "@care.border" },
            { "▘", "@care.border" },
            { "▀", "@care.border" },
            { "▝", "@care.border" },
            { "▐", "@care.border" },
        }
    elseif border_config == "rounded" then
        border = {
            { "╭", "@care.border" },
            { "─", "@care.border" },
            { "╮", "@care.border" },
            { "│", "@care.border" },
            { "╯", "@care.border" },
            { "─", "@care.border" },
            { "╰", "@care.border" },
            { "│", "@care.border" },
        }
    elseif border_config == "none" then
        border = ""
    elseif border_config == "up_to_edge" then
        border = {
            -- { "🭽", "@care.border" },
            -- { "▔", "@care.border" },
            -- { "🭾", "@care.border" },
            -- { "▕", "@care.border" },
            -- { "🭿", "@care.border" },
            -- { "▁", "@care.border" },
            -- { "🭼", "@care.border" },
            -- { "▏", "@care.border" },
            { "🬕", "@care.border" },
            { "🬂", "@care.border" },
            { "🬨", "@care.border" },
            { "▐", "@care.border" },
            { "🬷", "@care.border" },
            { "🬭", "@care.border" },
            { "🬲", "@care.border" },
            { "▌", "@care.border" },
        }
    end

    require("blink.cmp").setup({
        completion = {
            menu = {
                border = border,
                draw = {
                    align_to_component = "none",
                },
            },
            documentation = {
                auto_show = true,
            },
        },
    })
end

return blink
