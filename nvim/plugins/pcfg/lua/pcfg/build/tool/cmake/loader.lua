local Loader = require('pcfg.build.core.loader')
local CMakeTarget = require('pcfg.build.targets.cmake')

---@class CMakeLoader : Loader
---@field supported_targets table List of supported CMake target types
local CMakeLoader = {}
CMakeLoader.__index = CMakeLoader
setmetatable(CMakeLoader, { __index = Loader })

---Creates a new CMake loader instance
---@return CMakeLoader
function CMakeLoader:new()
    local instance = Loader:new({
        name = "cmake",
        patterns = { "CMakeLists.txt" }
    })
    instance.supported_targets = {
        "executable",
        "library",
        "custom",
    }
    setmetatable(instance, self)
    return instance
end

---Parses CMakeCache.txt to find targets
---@param dir string Project directory
---@param register_function function Function to register found targets
function CMakeLoader:load_targets(dir, register_function)
    local build_dir = dir .. "/build"
    local cache_file = build_dir .. "/CMakeCache.txt"

    if vim.fn.filereadable(cache_file) == 0 then
        return
    end

    for line in io.lines(cache_file) do
        -- Detect executable targets
        local name = line:match("^([^:]+)_EXECUTABLE:FILEPATH=(.+)$")
        if name then
            local target = CMakeTarget:new(
                name,
                build_dir,
                "Debug",
                "CMake executable target"
            )
            register_function(target)
        end

        -- Detect library targets
        name = line:match("^([^:]+)_LIBRARY:FILEPATH=(.+)$")
        if name then
            local target = CMakeTarget:new(
                name,
                build_dir,
                "Debug",
                "CMake library target"
            )
            register_function(target)
        end
    end
end

return CMakeLoader:new()