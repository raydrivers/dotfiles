local Mapper = {}

--- Parse function name and pass the right params
---@param f_name string The name of the function being called
---@param args string[] The arguments passed to the function
local function dispatch(f_name, args)
    local mode, attr = f_name:match("^(%w?)(%w*)map$")
    assert(mode, "Invalid remap function name: " .. f_name)

    local keymap_function = vim.api.nvim_set_keymap
    local bufnr = nil
    if attr:find("b") then
        keymap_function = vim.api.nvim_buf_set_keymap
        bufnr = table.remove(args, 1)
    end

    local lhs = args[1]
    local rhs = args[2]
    local user_opts = args[3] or {}

    local opts = {}
    opts.noremap = (attr:find("nore") ~= nil)
    opts.silent = true

    opts = vim.tbl_extend("force", opts, user_opts)

    if (not lhs or not rhs) then
        error("No lhs or rhs arguments provided: " .. tostring(lhs) .. " " .. tostring(rhs))
    end

    if bufnr then
        keymap_function(bufnr, mode, lhs, rhs, opts)
    else
        keymap_function(mode, lhs, rhs, opts)
    end
end

setmetatable(Mapper, {
    __index = function(_, f_name)
        return function(...)
            dispatch(f_name, { ... })
        end
    end,
})

return Mapper

