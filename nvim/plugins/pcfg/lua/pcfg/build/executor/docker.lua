local Executor = require("pcfg.build.core.executor")

-- TODO: composition - shell executor

---@class DockerExecutor : Executor Executes commands from shell
local DockerExecutor = {}
DockerExecutor.__index = {}
setmetatable(DockerExecutor, { __index = Executor })

---@param env table<string, string> Environment map
---@return boolean
---@diagnostic disable-next-line unused-local
function DockerExecutor:setup(env)
end

---@param cmd string[] Command to run
---@return boolean
---@diagnostic disable-next-line unused-local
function DockerExecutor:run(cmd)
end

---@return boolean
---@diagnostic disable-next-line unused-local
function DockerExecutor:exit()
end

return DockerExecutor

