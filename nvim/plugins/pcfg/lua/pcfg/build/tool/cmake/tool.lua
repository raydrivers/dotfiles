local BuildTool = require('pcfg.build.core.tool')
local CMakeConfig = require('pcfg.build.tool.cmake.config')
local log = require('pcfg.log')

---@class CMakeTool : BuildTool
local CMakeTool = setmetatable({}, { __index = BuildTool })
CMakeTool.__index = CMakeTool

local cmake = CMakeTool:new({
    name = "cmake",
    supported_types = { "executable", "library" }
})

local configs = {}
local targets = {}

function cmake.add_config(opts)
    local config = CMakeConfig:new(opts)
    configs[config.name] = config
    log.debug(string.format("Added CMake config: %s", config.name))
    return config
end

function cmake.get_config(name)
    return configs[name]
end

function cmake.add_target(opts)
    local target = CMakeTarget:new(opts)
    targets[target.name] = target
    log.debug(string.format("Added CMake target: %s", target.name))
    return target
end

function cmake.get_target(name)
    return targets[name]
end

return cmake