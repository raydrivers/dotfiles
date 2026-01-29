local tbl = require('plenary.tbl')

local log = require('pcfg.log')

---@class LoaderExtended : Loader
---@field tool string

---@class TargetExtended : Target
---@field tool string

---@class Manager Build configuration manager
---@field tools table<string, BuildTool> Map of registered build tools
---@field loaders LoaderExtended[] List of active loaders
---@field targets TargetExtended[] Map of available targets
local Manager = {}

Manager.tools = {}
Manager.loaders = {}
Manager.targets = {}

---Register a new loader instance
---@param loader Loader Loader instance to register
---@param tool_name string Tool name
function Manager:register_loader(loader, tool_name)
    local loader_extended = vim.tbl_extend("error", loader, { tool = tool_name, });
    log.trace(string.format("Registering loader: %s", loader.name))
    table.insert(self.loaders, tbl.freeze(loader_extended))
end

---Register a new target
---@param target Target Target instance to register
---@param tool_name string Tool associated with the target
function Manager:register_target(target, tool_name)
    local target_extended = vim.tbl_extend("error", target, { tool = tool_name, })
    log.trace(string.format("Registering target: %s", target.name))
    table.insert(self.targets, tbl.freeze(target_extended))
end

---Enable build tool and load its components
---@param tool_name string Tool name (cmake, make, etc)
---@param opts? table Tool-specific options
function Manager:enable_tool(tool_name, opts)
    local tool_module_name = "pcfg.build.tool." .. tool_name

    log.debug(string.format("Loading build tool module: %s", tool_module_name))
    local ok, tool = pcall(require, tool_module_name)
    if not ok then
        log.error(string.format("Failed to load tool %s: %s", tool_name, tool))
        return
    end

    if tool.setup then
        tool.setup(opts or {})
    end

    log.trace(string.format("Registering tool %s: %s", tool_name, tool_module_name))
    self.tools[tool_name] = tbl.freeze(tool)

    local loader_ok, loader = pcall(require, tool_module_name .. ".loader")
    if loader_ok then
        log.info(string.format("Loaded loader for tool: %s", tool_name))
        self:register_loader(loader, tool_name)
    end
end

---Load targets from all registered loaders for the specified directory
---@param dir string Project directory path
---@return number Number of loaded targets
function Manager:load_targets(dir)
    log.debug(string.format("Loading targets from directory: %s", dir))

    if #self.loaders == 0 then
        log.warn("No loaders registered")
        return 0
    end

    local loaded_targets = 0
    for _, loader in ipairs(self.loaders) do
        log.trace(string.format("Checking loader: %s", loader.name))
        if loader:is_supported(dir) then
            log.trace(string.format("Loader %s supports directory, loading targets", loader.name))

            loader:load_targets(dir, function(target)
                self:register_target(target, loader.tool)
                loaded_targets = loaded_targets + 1
            end)
        else
            log.debug("Loader doesn't support directory: %s", dir)
        end
    end

    log.info(string.format("Loaded %d targets", loaded_targets))
    return loaded_targets
end


---@param target_name string
---@return TargetExtended? Target if exists
function Manager:find_target(target_name)
    for _, item in ipairs(self.targets) do
        if item.name == target_name then
            return item
        end
    end

    return nil
end

---@param config_name string
---@return boolean
function Manager:configure(tool_name, config_name)
    local tool = self.tools[tool_name]
    if not tool then
        log.error("Tool doesn't exist: %s", tool_name)
        return false
    end

    local config = tool:find_config(config_name)
    if not config then
        log.error("Config doesn't exist: %s", config_name)
        return false
    end

    local cmd = tool:configure_command(config)
    local executor = config:get_executor()

    return executor:run(cmd)
end

---@param target_name string
---@return boolean
function Manager:build_target(target_name, config_name)
    local target = self:find_target(target_name)
    if not target then
        log.error("Target doesn't exist: %s", target_name)
        return false
    end

    local tool = self.tools[target.tool]
    if not tool then
        log.error("Tool doesn't exist: %s", target.tool)
        return false
    end

    local config = tool:find_config(config_name)
    if not config then
        log.error("Config doesn't exist: %s", config_name)
        return false
    end

    local cmd = tool:build_command(target, config)
    local executor = config:get_executor()

    return executor:run(cmd)
end

---Initialize build system manager
---Called internally during plugin setup
function Manager:setup()
    log.debug("Initializing build system manager")
end

return Manager

