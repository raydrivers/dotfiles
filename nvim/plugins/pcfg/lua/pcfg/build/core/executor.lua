---@class Executor
---@field name string
local Executor = {}
Executor.__index = Executor

local UNIMPLEMENTED_ERROR_MSG = "must be implemented by the executor subclass"

---@class ExecutorOpts
---@field name string

---@param opts ExecutorOpts
---@return boolean, string?
local function validate(opts)
    if not opts.name then return false, "name is required" end

    return true
end

---@param opts ExecutorOpts
---@return Executor
function Executor:new(opts)
    local ok, err = validate(opts)
    assert(ok, err)

    local instance = setmetatable({}, self)
    instance.name = opts.name
    return instance
end

--- Prepares executor for the work - opens session and sets up environment
---@param env table<string, string> Environment map
---@return boolean
---@diagnostic disable-next-line unused-local
function Executor:setup(env)
    error(UNIMPLEMENTED_ERROR_MSG)
end

---@param cmd string[] Command to run
---@return boolean
---@diagnostic disable-next-line unused-local
function Executor:run(cmd)
   error(UNIMPLEMENTED_ERROR_MSG)
end

---@return boolean
---@diagnostic disable-next-line unused-local
function Executor:exit()
   error(UNIMPLEMENTED_ERROR_MSG)
end

return Executor

