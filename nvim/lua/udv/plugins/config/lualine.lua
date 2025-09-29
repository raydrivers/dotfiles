local lualine = require("lualine")


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

-- Config
local config = {
    options = {
        disabled_filetypes = {
            "neo-tree",
            "dashboard",
        },
        component_separators = '',
        section_separators = '',
        theme = "auto",
    },
    sections = {
        lualine_a = {}, -- Mode section
        lualine_b = {}, -- File info section
        lualine_c = {}, -- Main Left section
        lualine_x = {}, -- Main right section
        lualine_y = {}, -- Info section
        lualine_z = {}, -- Status section
    },
    inactive_sections = {
        -- Reset defaults
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

ins_right_main {
    function()
        local msg = 'No Active LSP'
        local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
        local clients = vim.lsp.get_clients()
        if next(clients) == nil then
            return msg
        end
        for _, client in ipairs(clients) do
            local filetypes = client.config.filetypes
            if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                return client.name
            end
        end
        return msg
    end,
    icon = ' LSP:',
}

set_status {
    'location'
}

lualine.setup(config)

