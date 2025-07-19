local log = require("pcfg.log")

local Executor = require("pcfg.build.core.executor")

---@class ShellExecutor : Executor Executes commands from shell
---@field shell_buffer int 
local ShellExecutor = {}
ShellExecutor.__index = {}
setmetatable(ShellExecutor, { __index = Executor })

---@return ShellExecutor
function ShellExecutor:new()
    local instance = setmetatable({}, self)
    instance.shell_buffer = nil
    return instance
end

---@param env table<string, string> Environment map
---@return boolean
---@diagnostic disable-next-line unused-local
function ShellExecutor:setup(env)
    self:start_shell(env)
end

function ShellExecutor:start_shell()
    
end

---@param cmd string[] Command to run
---@return boolean
---@diagnostic disable-next-line unused-local
function ShellExecutor:run(cmd)
    if not self.shell_buffer then
        log.error("Shell must be started before a command can be executed")
        return false
    end

    local channel_id
end

---@return boolean
---@diagnostic disable-next-line unused-local
function ShellExecutor:exit()
end

return ShellExecutor

