local Path = require('plenary.path')

local log = require('pcfg.log')

local BuildConfig = require('pcfg.build.core.config')

---@class CMakeBuildConfig : BuildConfig
---@field generator string CMake generator
---@field build_type string Build configuration type
---@field toolchain string? Path to toolchain file
local CMakeBuildConfig = setmetatable({}, {
    __index = BuildConfig
})
CMakeBuildConfig.__index = CMakeBuildConfig

---@class CMakeBuildConfigOpts : BuildConfigOpts
---@field generator string
---@field build_type string
---@field toolchain string?

-- Supported generators and their multi-config capability
local MULTI_CONFIG_GENERATORS = {
    "Ninja Multi-Config",
    "Visual Studio 17 2022",
    "Xcode",
}

---@param opts table Configuration options
---@return boolean is_valid
---@return string? error_message
local function validate(opts)
    if not opts.name then
        return false, "name is required"
    end

    if not opts.generator then
        return false, "generator is required"
    end

    if not opts.build_type then
        return false, "build_type is required"
    end

    return true
end

---Create new CMake build configuration
---@param opts table Configuration table
---@field build_dir string Build directory
---@field generator string CMake generator
---@field build_type string Build type (required for single-config generators)
---@field toolchain? string Path to toolchain file
---@field options? table<string,string> CMake options
---@field env? table<string,string> Environment variables
function CMakeBuildConfig:new(opts)
    local ok, err = validate(opts)
    assert(ok, err)

    local instance = setmetatable({}, self)
    instance.name = opts.name
    instance.build_dir = Path:new(opts.build_dir):absolute()
    instance.generator = opts.generator
    instance.build_type = opts.build_type
    instance.toolchain = opts.toolchain
    instance.options = opts.options or {}
    instance.env = opts.env or {}

    log.debug(string.format("[CMake] Created build config %s with %s generator: %s", instance.name, instance.generator,
        instance.build_dir))
    return instance
end

---Check if current generator is multi-config
---@return boolean
function CMakeBuildConfig:is_multi_config()
    for _, generator in ipairs(MULTI_CONFIG_GENERATORS) do
        if generator == self.generator then
            return true
        end
    end
    return false
end

---Get CMake configuration arguments
---@return string[] args CMake configuration arguments
function CMakeBuildConfig:get_configure_args()
    local args = {"-G", self.generator}

    if not self:is_multi_config() and self.build_type then
        table.insert(args, "-DCMAKE_BUILD_TYPE=" .. self.build_type)
    end

    if self.toolchain then
        table.insert(args, "-DCMAKE_TOOLCHAIN_FILE=" .. self.toolchain)
    end

    for k, v in pairs(self.options) do
        table.insert(args, "-D" .. k .. "=" .. v)
    end

    return args
end

---Get CMake build arguments
---@return string[] args CMake build arguments
function CMakeBuildConfig:get_build_args()
    local args = {}

    if self:is_multi_config() and self.build_type then
        table.insert(args, "--config")
        table.insert(args, self.build_type)
    end

    return args
end

return CMakeBuildConfig
