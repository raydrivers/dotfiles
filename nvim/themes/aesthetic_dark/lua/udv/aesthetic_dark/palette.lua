local lush = require("lush")
local hsl = lush.hsl

-- TODO: standardize color names, more descriptive names

local base_colors = {
    charcoal    = hsl(220, 9, 13),
    steel_blue  = hsl(204, 37, 59),
    lavender    = hsl(276, 17, 66),
    muted_green = hsl(92, 14, 55),
    light_gray  = hsl(210, 8, 90),
    tan         = hsl(29, 65, 65),
    teal        = hsl(178, 14, 53),
    dark_red    = hsl(355, 46, 56),
}

local additional_colors = {
    yellow = hsl(55, 60, 60),
}

local context_colors = {
    vcs = {
        added    = base_colors.teal,
        removed  = base_colors.light_gray.darken(48),
        modified = base_colors.steel_blue,
        conflict = base_colors.dark_red,
    }
}

return vim.tbl_extend("error", base_colors, additional_colors, context_colors)
