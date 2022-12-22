local refactoring = {}

function refactoring.find_duplicate_lines()
    local common = { "end", ")", "})", "}" }
    local printed = {}
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    for nr, line in ipairs(lines) do
        local printed_line = false
        for match_nr, match_line in ipairs(lines) do
            if
                match_nr ~= nr
                and match_line == line
                and line ~= ""
                and not vim.tbl_contains(common, line:match("%s-([^%s]+)%s-"))
                and not vim.tbl_contains(printed, nr)
            then
                print(nr, "(", match_nr, ")")
                printed_line = true
            end
        end
        if printed_line then
            table.insert(printed, nr)
        end
    end
end

return refactoring
