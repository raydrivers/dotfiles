local ShellExecutor = require("pcfg.build.executor.shell")

---@class BuildConfig
---@field name string Configuration name 
---@field build_dir string Build directory path, relative to the source root
---@field env table<string, string> Environment variables table 
---@field options table<string, string> Tool-specific command line options 
---@field executor Executor
local BuildConfig = {}
BuildConfig.__index = BuildConfig
BuildConfig.__eq = BuildConfig.equals

---@class BuildConfigOpts Table used for creating BuildConfig object
---@field name string Configuration name 
---@field build_dir string Build directory path, relative to the source root
---@field env table<string, string>? Environment variables table 
---@field options table<string, string>? Tool-specific command line options 
---@field executor Executor? Executor that you will use in the config

---@param opts BuildConfigOpts
---@return boolean, string? 
local function validate(opts)
    if not opts.name then return false, "name is required" end
    if not opts.build_dir then return false, "build_dir required" end

    return true
end

---@param opts BuildConfigOpts
function BuildConfig:new(opts)
    local ok, err = validate(opts)
    assert(ok, err)

    local instance = setmetatable({}, self)
    instance.name = opts.name
    instance.build_dir = opts.build_dir
    instance.env = vim.tbl_deep_extend("force", {}, opts.env or {})
    instance.options = vim.tbl_deep_extend("force", {}, opts.options or {})
    instance.executor = opts.executor or ShellExecutor:new({ name = "shell-" .. opts.name })
    return instance
end

---@param config BuildConfig
---@return boolean
function BuildConfig:equals(config)
    return self.name == config.name
end

---@return table<string, string> Environment The current environent
function BuildConfig:get_env()
    return vim.tbl_deep_extend("force", {}, self.env)
end

---@return table<string, any> Options Build tool options
function BuildConfig:get_options()
    return vim.tbl_deep_extend("force", {}, self.options)
end

---@return Executor
function BuildConfig:get_executor()
    return self.executor
end

return BuildConfig

