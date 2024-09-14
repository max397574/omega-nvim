local M = {}

local function strip_archive_subpath(path)
    path = vim.fn.substitute(path, "zipfile://\\(.\\{-}\\)::[^\\\\].*$", "\\1", "")
    path = vim.fn.substitute(path, "tarfile:\\(.\\{-}\\)::.*$", "\\1", "")
    return path
end

local function escape_wildcards(path)
    return path:gsub("([%[%]%?%*])", "\\%1")
end

local function search_ancestors(startpath, func)
    if func(startpath) then
        return startpath
    end
    local guard = 100
    for path in vim.fs.parents(startpath) do
        -- Prevent infinite recursion if our algorithm breaks
        guard = guard - 1
        if guard == 0 then
            return
        end

        if func(path) then
            return path
        end
    end
end

function M.root_pattern(...)
    local patterns = vim.iter({ ... }):flatten(math.huge):totable()
    return function(startpath)
        startpath = strip_archive_subpath(startpath)
        for _, pattern in ipairs(patterns) do
            local match = search_ancestors(startpath, function(path)
                for _, p in
                    ipairs(
                        vim.fn.glob(
                            table.concat(
                                vim.iter({ escape_wildcards(path), pattern }):flatten(math.huge):totable(),
                                "/"
                            ),
                            true,
                            true
                        )
                    )
                do
                    local stat = vim.uv.fs_stat(p)
                    if stat and stat.type then
                        return path
                    end
                end
            end)

            if match ~= nil then
                return match
            end
        end
    end
end

return M
