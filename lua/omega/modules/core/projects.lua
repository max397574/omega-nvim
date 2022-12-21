---@type OmegaModule
local project_mod = {}

project_mod.configs = {
    ["projects.nvim"] = function()
        local Project = require("projects.projects")
    end,
}

return project_mod
