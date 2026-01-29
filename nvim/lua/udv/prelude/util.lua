local function is_module_available(name)
    if package.loaded[name] then
        return true
    end

    local searchers = package.searchers
    if not searchers then
        return false
    end

    for _, searcher in ipairs(searchers) do
        local success, loader = pcall(searcher, name)
        if success and type(loader) == "function" then
            return true
        end
    end

    return false
end

local function format_load_error(name, err)
    local lines = {
        "\nModule load error: " .. name,
        "Error: " .. tostring(err),
        "\nSearch paths:"
    }

    local normalized_name = name:gsub("%.", package.config:sub(1, 1)) -- Get platform-specific separator

    for path in package.path:gmatch("[^;]+") do
        local formatted_path = path:gsub("?", normalized_name)
        table.insert(lines, "  " .. formatted_path)
    end

    table.insert(lines, "\nStack trace:")
    table.insert(lines, debug.traceback("", 2))

    return table.concat(lines, "\n")
end


local function safe_require(name)
    if not is_module_available(name) then
        return nil
    end

    local ok, result = pcall(require, name)
    if ok then
        return result
    end

    error(format_load_error(name, result))
end

return {
    safe_require = safe_require,
}

