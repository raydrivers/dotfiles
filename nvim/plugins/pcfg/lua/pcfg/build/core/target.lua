---@enum (key) TargetType
local TargetType = {
    CUSTOM = 0,
    LIBRARY = 1,
    EXECUTABLE = 2,
}

---@class Target
---@field name string Target name
---@field type TargetType Target type
---@field dependencies string[] List of target dependencies
---@field metadata table Additional target-specific data
local Target = {}
Target.__index = Target

---@class TargetOpts Table used to create a target instance
---@field name string Target name
---@field type string Target type

---Validates target configuration
---@param opts table Configuration table
---@return boolean is_valid
---@return string? error_message
local function validate(opts)
    if not opts.name then return false, "name is required" end
    if not opts.type then return false, "type is required" end
    if not vim.tbl_contains(TargetType, opts.type) then
        return false, "Invalid type: " .. opts.type
    end
    return true
end

---Creates a new target instance
---@param opts TargetOpts Configuration table
---@return Target
function Target:new(opts)
    local is_valid, error_message = validate(opts)
    assert(is_valid, error_message)

    local instance = setmetatable({}, self)
    instance.name = opts.name
    instance.type = opts.type
    return instance
end

---Get target information as a table
---@return table Target information
function Target:get_info()
    return {
        name = self.name,
        type = self.type,
    }
end

---Pretty print target information
function Target:info()
    print(string.format("Target: %s (%s)", self.name, self.type))
end

return Target
