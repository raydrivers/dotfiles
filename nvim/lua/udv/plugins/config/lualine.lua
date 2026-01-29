local lualine = require("lualine")

local trailing_ws = {}
local harpoon_index = {}

local function check_trailing_ws(buf)
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for _, line in ipairs(lines) do
        if line:match("%s$") then
            trailing_ws[buf] = true
            return
        end
    end
    trailing_ws[buf] = false
end

local function check_harpoon(buf)
    local ok, harpoon = pcall(require, "harpoon")
    if not ok then
        return
    end

    local filepath = vim.api.nvim_buf_get_name(buf)
    if filepath == "" then
        harpoon_index[buf] = nil
        return
    end

    local list = harpoon:list()
    for i = 1, list:length() do
        local item = list:get(i)
        if item and item.value
            and vim.fn.fnamemodify(item.value, ":p") == filepath
        then
            harpoon_index[buf] = i
            return
        end
    end
    harpoon_index[buf] = nil
end

vim.api.nvim_create_autocmd(
    { "TextChanged", "InsertLeave", "BufEnter" },
    { callback = function(ev) check_trailing_ws(ev.buf) end }
)

vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(ev) check_harpoon(ev.buf) end,
})

vim.api.nvim_create_autocmd("BufDelete", {
    callback = function(ev)
        trailing_ws[ev.buf] = nil
        harpoon_index[ev.buf] = nil
    end,
})

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
    end,
    hide_in_width = function()
        return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
        local filepath = vim.fn.expand('%:p:h')
        local gitdir = vim.fn.finddir('.git', filepath .. ';')
        return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
}

local config = {
    options = {
        disabled_filetypes = {},
        component_separators = '',
        section_separators = '',
        theme = "auto",
    },
    sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
    },
}

local function set_mode(component)
    config.sections.lualine_a = { component }
end

local function ins_left_main(component)
    if #config.sections.lualine_b >= 2 then
        error("ins_left_main: lualine_b section already has 2 components, cannot add more")
    end
    table.insert(config.sections.lualine_b, component)
end

local function ins_right_main(component)
    if #config.sections.lualine_y >= 2 then
        error("ins_right_main: lualine_y section already has 2 components, cannot add more")
    end
    table.insert(config.sections.lualine_y, component)
end

local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

local function set_status(component)
    config.sections.lualine_z = { component }
end

set_mode {
    function()
        local mode = vim.fn.mode()
        local mode_names = {
            n =       "NORMAL",
            i =       "INSERT",
            v =       "VISUAL",
            [''] =  "VISUAL BLOCK",
            V =       "VISUAL LINE",
            c =       "COMMAND",
            no =      "OPERATOR PENDING",
            s =       "SELECT",
            S =       "SELECT LINE",
            [''] =  "SELECT BLOCK",
            ic =      "INSERT COMPLETION",
            R =       "REPLACE",
            Rv =      "VIRTUAL REPLACE",
            cv =      "EX COMMAND",
            ce =      "EX COMMAND",
            r =       "PROMPT",
            rm =      "MORE",
            ['r?'] =  "CONFIRM",
            ['!'] =   "SHELL",
            t =       "TERMINAL",
        }
        return "∛ " .. (mode_names[mode] or mode)
    end,
}

ins_left_main {
    'filesize',
    cond = conditions.buffer_not_empty,
}

ins_left_main {
    'filename',
    cond = conditions.buffer_not_empty,
}

ins_left {
    'o:encoding',
    fmt = string.upper,
    cond = conditions.hide_in_width,
}

ins_left {
    'branch',
    icon = '',
}

ins_right {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
}

ins_right {
    'filetype',
}

ins_right_main {
    function()
        local buf = vim.api.nvim_get_current_buf()
        local indicators = {}

        local idx = harpoon_index[buf]
        if idx then
            table.insert(indicators, "♆ " .. idx)
        end

        if trailing_ws[buf] then
            table.insert(indicators, "⚐")
        end

        return table.concat(indicators, " ")
    end,
}

set_status {
    'location'
}

lualine.setup(config)
