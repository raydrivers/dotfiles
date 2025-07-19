---@class BuildTool An interface for all build tools to implement
---                 Tools are responsible for composing commands on targets
---@field name string Tool name
---@field configs BuildConfig[] List of available configurations
local BuildTool = {}
BuildTool.__index = BuildTool

BuildTool.configs = {}

---@class BuildToolOpts Table of options for creating a BuildTool object
---@field name string 

local UNIMPLEMENTED_ERROR_MSG = "must be implemented by derived tools"

---@param opts BuildToolOpts
---@return boolean, string? ValidationStatus
local function validate(opts)
    if not opts.name then return false, "name is required" end
    return true
end

---@param opts BuildToolOpts
---@return BuildTool instance
function BuildTool:new(opts)
    local ok, err = validate(opts)
    assert(ok, err)

    local instance = setmetatable({}, self)
    instance.name = opts.name
    return instance
end

---@param config BuildConfig
---@diagnostic disable-next-line unused-local
function BuildTool:add_config(config)
    error(UNIMPLEMENTED_ERROR_MSG)
end

---@param config_name string
---@return BuildConfig?
function BuildTool:find_config(config_name)
    for _, item in self.configs do
        if item.name == config_name then
            return item
        end
    end

    return nil
end

---@param config BuildConfig 
---@return string[] command Configure command for a specified configuration
---@diagnostic disable-next-line unused-local
function BuildTool:configure_command(config)
    error(UNIMPLEMENTED_ERROR_MSG)
end

---@param target Target
---@param config BuildConfig
---@return string[] command Command line for building the target in the specified config
---@diagnostic disable-next-line unused-local
function BuildTool:build_command(target, config)
    error(UNIMPLEMENTED_ERROR_MSG)
end

---@param target Target
---@param config BuildConfig
---@return string[] command Command line for running the target in the specified config
---@diagnostic disable-next-line unused-local
function BuildTool:run_command(target, config)
    error(UNIMPLEMENTED_ERROR_MSG)
end

return BuildTool

