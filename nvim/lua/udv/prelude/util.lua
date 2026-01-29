local function format_load_error(name, err)
    local lines = {
        "\nModule load error: " .. name,
        "Error: " .. tostring(err),
        "\nSearch paths:"
    }

    local normalized_name = name:gsub("%.", package.config:sub(1, 1))

    for path in package.path:gmatch("[^;]+") do
        local formatted_path = path:gsub("?", normalized_name)
        table.insert(lines, "  " .. formatted_path)
    end

    table.insert(lines, "\nStack trace:")
    table.insert(lines, debug.traceback("", 2))

    return table.concat(lines, "\n")
end


local function safe_require(name)
    local ok, result = pcall(require, name)
    if ok then
        return result
    end

    if result:match("module .* not found") then
        return nil
    end

    error(format_load_error(name, result))
end

return {
    safe_require = safe_require,
}

