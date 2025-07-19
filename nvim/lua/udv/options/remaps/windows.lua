local RESIZE_STEP = "4"

---@class ParamsByAxis
---@field position integer The position of the current window by given axis
---@field size integer The size of the current window by given axis
---@field screen_size integer Screen dimension by given axis

---@alias Axis
---| '"vertical"'   # Vertical axis
---| '"horizontal"' # Horizontal axis

---@alias Direction
---| `true`  Positive direction (+)
---| `false` Negative direction (-)

---@param axis Axis
---@return Axis
local function convert_to_nvim_axis(axis)
    if axis == "vertical" then
        return "horizontal"
    end

    if axis == "horizontal" then
        return "vertical"
    end

    error("Wrong axis: " .. axis)
end

---@param axis Axis 
---@param direction Direction
---@return string
local function resize_cmd(axis, direction)
    local sign = ""

    if direction then
        sign = "+"
    else
        sign = "-"
    end

    axis = convert_to_nvim_axis(axis)

    return axis .. " resize " .. sign .. RESIZE_STEP
end

---@param axis Axis
---@param win integer
---@return ParamsByAxis
local function axis_params(axis, win)
    local position = 0
    local size = 0
    local screen_size = 0

    local win_pos = vim.api.nvim_win_get_position(win)
    local win_x = win_pos[2]
    local win_y = win_pos[1]

    if axis == "vertical" then
        position = win_y
        size = vim.api.nvim_win_get_height(win)
        screen_size = vim.opt.lines:get()
    elseif axis == "horizontal" then
        position = win_x
        size = vim.api.nvim_win_get_width(win)
        screen_size = vim.opt.columns:get()
    else
        error("Wrong axis: " .. axis)
    end

    return {
        position = position,
        size = size,
        screen_size = screen_size,
    }
end

---@param params ParamsByAxis
---@param axis Axis
---@return boolean
local function should_invert_direction(params, axis)
    local position    = params.position
    local size        = params.size
    local screen_size = params.screen_size

    if axis == "vertical" then
        local STATUS_LINE_HEIGHT = 1
        screen_size = screen_size
            - vim.o.cmdheight
            - STATUS_LINE_HEIGHT
    end

    local size_matches = (position + size == screen_size)

    return size_matches
end

---@param direction Direction
---@return Direction
local function invert_direction(direction)
    return not direction
end

local function resize_axis(axis, direction)
    local win = vim.api.nvim_get_current_win()
    local params = axis_params(axis, win)

    if should_invert_direction(params, axis) then
        direction = invert_direction(direction)
    end

    local cmd = resize_cmd(axis, direction)

    vim.cmd(cmd)
end

---@param direction Direction
local function resize_x(direction)
    resize_axis("horizontal", direction)
end

---@param direction Direction
local function resize_y(direction)
    resize_axis("vertical", direction)
end

local function resize_up()
    resize_y(false)
end

local function resize_down()
    resize_y(true)
end

local function resize_left()
    resize_x(false)
end

local function resize_right()
    resize_x(true)
end

vim.keymap.set('n', '<M-h>', resize_left,  { desc = "Resize left" })
vim.keymap.set('n', '<M-j>', resize_down,  { desc = "Resize down" })
vim.keymap.set('n', '<M-k>', resize_up,    { desc = "Resize up" })
vim.keymap.set('n', '<M-l>', resize_right, { desc = "Resize right" })

