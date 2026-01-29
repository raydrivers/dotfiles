local Path = require('plenary.path')
local paths = require("pcfg.paths")
local log = require("pcfg.log")

local M = {}

function M.load_project_snippets(project_root)
    log.debug(string.format("Loading project snippets from: %s", project_root))

    local config_dir = Path:new(project_root) / paths.PROJECT_CONFIG_DIR
    local snippets_dir = config_dir / "snippets"

    -- Check if project has snippets directory
    if snippets_dir:exists() and snippets_dir:is_dir() then
        log.debug(string.format("Found project snippets directory: %s", snippets_dir))

        -- Use LuaSnip's built-in loader with project path
        require("luasnip.loaders.from_lua").lazy_load({
            paths = { snippets_dir.filename }
        })

        log.debug("Project snippets loaded via LuaSnip loader")
    else
        log.trace("No project snippets directory found")
    end
end

function M.setup()
    log.trace("Setting up pcfg snippets module")
    -- LuaSnip's lua loader already provides hot reload,
    -- so we don't need to implement our own!
end

return M