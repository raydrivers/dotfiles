local palette = require("udv.aesthetic_dark.palette")

-- Convert HSL colors to hex format for lualine
local function to_hex(color)
    return color.hex
end

local colors = {
    bg = to_hex(palette.charcoal),
    bg_light = to_hex(palette.charcoal.lighten(8)),
    fg = to_hex(palette.light_gray),
    fg_dim = to_hex(palette.light_gray.darken(24)),
    
    -- Mode colors
    normal = to_hex(palette.teal.darken(24)),
    insert = to_hex(palette.dark_red),
    visual = to_hex(palette.steel_blue.saturate(24)),
    replace = to_hex(palette.lavender.darken(24)),
    command = to_hex(palette.muted_green.darken(24)),
    
    -- Component colors
    accent = to_hex(palette.lavender),
    green = to_hex(palette.muted_green),
    red = to_hex(palette.dark_red),
    yellow = to_hex(palette.yellow),
    blue = to_hex(palette.steel_blue),
    teal = to_hex(palette.teal),
}

local aesthetic_dark = {
    normal = {
        a = { bg = colors.normal, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_light, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg_dim },
    },
    insert = {
        a = { bg = colors.insert, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_light, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg_dim },
    },
    visual = {
        a = { bg = colors.visual, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_light, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg_dim },
    },
    replace = {
        a = { bg = colors.replace, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_light, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg_dim },
    },
    command = {
        a = { bg = colors.command, fg = colors.bg, gui = 'bold' },
        b = { bg = colors.bg_light, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg_dim },
    },
    inactive = {
        a = { bg = colors.bg_light, fg = colors.fg_dim },
        b = { bg = colors.bg_light, fg = colors.fg_dim },
        c = { bg = colors.bg, fg = colors.fg_dim },
    },
}

return aesthetic_dark
