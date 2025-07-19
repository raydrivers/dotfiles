local wk = require("which-key")

local config = {
    preset = "classic",
    plugins = {
        marks = true,
        registers = true,
        spelling = {
            enabled = true,
            suggestions = 20
        },
        presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
        }
    },
    win = {
        border = "single",
        title = true,
        title_pos = "center",
        padding = {1, 1},
        no_overlap = true,
        zindex = 1000
    },
    icons = {
        breadcrumb = ">>",
        separator = " ",
        group = "+",
        mappings = false
    },
    layout = {
        width = {
            min = 24
        },
        spacing = 4
    },
    triggers = {
        { "<auto>", mode = "nxso" },
    },
    show_help = true,
    show_keys = true
}

wk.setup(config)
