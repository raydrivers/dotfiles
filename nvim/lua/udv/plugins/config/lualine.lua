-- Inspired by https://github.com/nvim-lualine/lualine.nvim/blob/master/examples/evil_lualine.lua
-- Idea of left/right components is intuitive

local lualine = require("lualine")

local function hl(group)
    local hl = vim.api.nvim_get_hl_by_name(group, true)
    
    hl.bg = hl.background and string.format("#%06x", hl.background) or nil
    hl.fg = hl.foreground and string.format("#%06x", hl.foreground) or nil
    hl.sp = hl.special and string.format("#%06x", hl.special) or nil

    return hl
end

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

local theme = {
    -- We are going to use lualine_c an lualine_x as left and
    -- right section. Both are highlighted by c theme .  So we
    -- are just setting default looks o statusline
    normal = {
        c = hl("Lualine"),
    },
    inactive = {
        c = hl("LualineInactive"),
    },
}

-- Config
local config = {
    options = {
        disabled_filetypes = {
            "neo-tree",
            "dashboard",
        },
        -- Disable sections and component separators
        component_separators = '',
        section_separators = '',
        theme = theme,
    },
    sections = {
        -- Reset defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
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

local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
end

ins_left {
    function()
        return '▊'
    end,
    color = hl("LualineIndicator"),
    padding = { left = 0, right = 1 },
}

ins_left {
    -- mode component
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
    color = function()
        local mode = vim.fn.mode()
        local mode_color = {
            n =       hl("LualineModeNormal"),
            i =       hl("LualineModeInsert"),
            v =       hl("LualineModeVisual"),
            [''] =  hl("LualineModeVisual"),
            V =       hl("LualineModeVisual"),
            c =       hl("LualineModeCommand"),
            no =      hl("LualineModeNormal"),
            s =       hl("LualineModeSelect"),
            S =       hl("LualineModeSelect"),
            [''] =  hl("LualineModeSelect"),
            ic =      hl("LualineModeInsertCompletion"),
            R =       hl("LualineModeReplace"),
            Rv =      hl("LualineModeReplace"),
            cv =      hl("LualineModeNormal"),
            ce =      hl("LualineModeNormal"),
            r =       hl("LualineModePrompt"),
            rm =      hl("LualineModePrompt"),
            ['r?'] =  hl("LualineModePrompt"),
            ['!'] =   hl("LualineModeNormal"),
            t =       hl("LualineModeTerminal"),
        }
        return mode_color[mode]
    end,
    padding = { left = 2, right = 2 },
}

ins_left {
    'filesize',
    cond = conditions.buffer_not_empty,
}

ins_left {
    'filename',
    cond = conditions.buffer_not_empty,
    color = hl("LualineCFilename"),
}

ins_left {
    'location',
    color = hl("LualineCProgress"),
}

ins_left {
    'progress',
    color = hl("LualineCProgress"),
}

ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
        error = hl("LualineCDiagnosticError"),
        warn  = hl("LualineCDiagnosticWarn"),
        info  = hl("LualineCDiagnosticInfo"),
    },
}

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left {
    function()
        return '%='
    end,
}

-- Add components to right sections
ins_right {
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
    color = hl("LualineCLSP")
}

ins_right {
    'o:encoding',
    fmt = string.upper,
    cond = conditions.hide_in_width,
    color = hl("LualineCEncoding")
}

ins_right {
    'fileformat',
    fmt = string.upper,
    icons_enabled = true,
    color = hl("LualineCFileformat")
}

ins_right {
    'branch',
    icon = '',
    color = hl("LualineCVCSBranch")
}

ins_right {
    'diff',
    symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
    diff_color = {
        added    = hl("LualineCVCSDiffAdded"),
        removed  = hl("LualineCVCSDiffRemoved"),
        modified = hl("LualineCVCSDiffModified"),
    },
    cond = conditions.hide_in_width,
}

ins_right {
    function()
        return '▊'
    end,
    color = hl("LualineIndicator"),
    padding = { left = 1, right = 0, },
}

-- Initialization
lualine.setup(config)