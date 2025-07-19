local log = require('pcfg.log')

---@class Loader
---@field name string Loader name
local Loader = {}
Loader.__index = Loader

---Validates loader configuration
---@param opts table Configuration table
---@return boolean is_valid
---@return string? error_message
local function validate(opts)
    if not opts.name then
        return false, "Loader name is required"
    end

    return true
end

---Creates a new loader instance
---@param opts table Configuration table
---@return Loader
function Loader:new(opts)
    local is_valid, error_message = validate(opts)
    assert(is_valid, error_message)

    log.debug(string.format("[%s] Creating new loader instance", opts.name))

    local instance = setmetatable({}, self)
    instance.name = opts.name
    return instance
end

---Checks if project supports this loader
---@param dir string Project directory
---@return boolean
---@diagnostic disable-next-line unused-local
function Loader:is_supported(dir)
    error("must be implemented by loader subclasses")
end

---Load targets from the specified directory
---@param dir string Project directory path
---@param register_fn fun(target: Target) Callback to register loaded target
---@return number Number of loaded targets
---@diagnostic disable-next-line unused-local
function Loader:load_targets(dir, register_fn)
    error("load_targets must be implemented by derived loaders")
end

