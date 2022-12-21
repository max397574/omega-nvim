local surround = {}

surround.configs = {
    ["nvim-surround"] = function()
        local get_input = function(prompt)
            local ok, result = pcall(vim.fn.input, { prompt = prompt })
            if not ok then
                return nil
            end
            return result
        end
        require("nvim-surround").setup({
            surrounds = {
                ["("] = { add = { "( ", " )" } },
                [")"] = { add = { "(", ")" } },
                ["{"] = { add = { "{ ", " }" } },
                [""] = { add = { "{", "}" } },
                ["<"] = { add = { "< ", " >" } },
                [">"] = { add = { "<", ">" } },
                ["["] = { add = { "[ ", " ]" } },
                ["]"] = { add = { "[", "]" } },
                ["\\"] = {
                    add = function()
                        local input = get_input("Enter environment name: ")
                        if input then
                            local aliases = {
                                ["bold"] = "textbf",
                                ["italic"] = "textit",
                            }
                            input = aliases[input] or input
                            return { { "\\" .. input .. "{" }, { "}" } }
                        end
                    end,
                },
                ["i"] = {
                    add = function()
                        local left_delimiter = get_input("Enter the left delimiter: ")
                        if left_delimiter then
                            local right_delimiter = get_input("Enter the right delimiter: ")
                            if right_delimiter then
                                return { { left_delimiter }, { right_delimiter } }
                            end
                        end
                    end,
                },
                ["f"] = {
                    add = function()
                        local result = get_input("Enter the function name: ")
                        if result then
                            return { { result .. "(" }, { ")" } }
                        end
                    end,
                    find = "[%w_]+%b()",
                    delete = "^([%w_]+%()().-(%))()$",
                    change = {
                        target = "^([%w_]+)().-()()$",
                        replacement = function()
                            local result = get_input("Enter the function name: ")
                            if result then
                                return { { result }, { "" } }
                            end
                        end,
                    },
                },
                ["'"] = { add = { "'", "'" } },
                ['"'] = { add = { '"', '"' } },
                ["`"] = { add = { "`", "`" } },
                HTML = {
                    ["t"] = "type",
                    ["T"] = "whole",
                },
                aliases = {
                    ["a"] = ">",
                    ["b"] = ")",
                    ["B"] = "}",
                    ["r"] = "]",
                    ["q"] = { '"', "'", "`" },
                    ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
                },
            },
            highlight = {
                duration = 300,
            },
            move_cursor = false,
        })
        vim.api.nvim_set_hl(0, "NvimSurroundHighlight", { link = "CurSearch" })
    end,
}

return surround
