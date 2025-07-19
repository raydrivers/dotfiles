local Path = require('plenary.path')

-- TODO: build part is disabled for now
-- local build = require("pcfg.build")
local paths = require("pcfg.paths")
local log = require("pcfg.log")

local Pcfg = {}

local function find_project_root()
    log.trace("Searching for project root directory")
    
    local current_dir = Path:new(vim.fn.getcwd())
    local config_dir = current_dir:find_upwards(paths.PROJECT_CONFIG_DIR)

    if config_dir then
        local project_root = Path:new(config_dir):parent()
        log.trace(string.format("Found project root: %s", project_root))
        return project_root
    end

    log.warn("No project root directory found, create %s directory", paths.PROJECT_CONFIG_DIR)
    return nil
end


local function on_project_loaded(project_root)
    log.debug(string.format("Project %s loaded, setting up", project_root))

    -- build.load_targets(project_root)
end

function Pcfg.load_project_config()
    log.trace("Loading project configuration, in %s", vim.fn.getcwd())

    local project_root = find_project_root()
    if not project_root then
        return
    end

    local config_dir = project_root / paths.PROJECT_CONFIG_DIR
    local lua_files = vim.fn.glob(config_dir.filename .. "/*.lua", false, true)

    log.trace(string.format("Found %d configuration files in %s", #lua_files, config_dir))
    for _, file in ipairs(lua_files) do
        log.debug(string.format("Loading config file: %s", file))
        dofile(file)
    end

    on_project_loaded(project_root)
end

function Pcfg.setup()
    log.trace("Initializing pcfg plugin")
    -- build.setup()

    log.debug("Setting up VimEnter autocmd for project config loading")
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = Pcfg.load_project_config,
    })
end

return Pcfg
