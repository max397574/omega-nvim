local abbreviations = {
    vorallem = "vor allem",
}

for lhs, rhs in pairs(abbreviations) do
    vim.cmd.inoreabbrev(lhs, rhs)
end
