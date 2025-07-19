local Target = require('pcfg.build.core.target')
local log = require('pcfg.log')

---@class CMakeTarget : Target
local CMakeTarget = setmetatable({}, { __index = Target })
CMakeTarget.__index = CMakeTarget

---@class CMakeTargetOpts : TargetOpts

---@param opts CMakeTargetOpts
---@return boolean success
---@return string? error
---@diagnostic disable-next-line unused-local
local function validate_cmake_opts(opts)
    return true
end

---@param opts CMakeTargetOpts
function CMakeTarget:new(opts)
    local ok, err = validate_cmake_opts(opts)
    assert(ok, err)

    local target = Target:new(opts)

    log.debug(string.format("[CMake] Creating target %s (%s)", opts.name, opts.type))
    return setmetatable(target, self)
end

return CMakeTarget

