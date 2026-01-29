local manager = require("pcfg.build.core.manager")
local log = require("pcfg.log")

local BuildModule = {}

--- Add a generic build target
---@param params table Parameters to define a generic build target
function BuildModule.add_target(params)
    log.trace(string.format("Adding target %s", params.name or "unknown"))
    manager:add_target(params)
end

--- List all registered build targets
function BuildModule.list_targets()
    manager:list_targets()
end

--- Run a specific build target
function BuildModule.run_target(name)
    log.trace(string.format("Running target %s", name))
    manager:run_target(name)
end

--- Enable build tool for the project
function BuildModule.enable_tool(name)
    log.trace(string.format("Enabling tool: %s", name))
    local tool = manager:enable_tool(name)

    if not tool then
        log.error(string.format("Failed to enable tool: %s", name))
        return
    end

    return tool
end

--- Use loader to auto-populate targets list
function BuildModule.load_targets(dir)
    log.trace(string.format("Loading targets from %s", dir))
    manager:load_targets(dir)
end

function BuildModule.setup()
    log.trace("Setting up pcfg.build")
    manager:setup()

    vim.api.nvim_create_user_command("Build", function(opts)
        local config = opts.fargs[1]
        local target = opts.fargs[2]
        manager:build_target(target, config)
    end, {
        nargs = "*",
        complete = function(_, line)
            return manager:complete_build_args(line)
        end
    })

    vim.api.nvim_create_user_command("Clean", function(opts)
        local config = opts.fargs[1]
        local target = opts.fargs[2]
        manager:clean_target(config, target)
    end, {
        nargs = "*",
        complete = function(_, line)
            return manager:complete_clean_args(line)
        end
    })
end

return BuildModule
