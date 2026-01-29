local oil = require("oil")

local config = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
        show_hidden = true,
        natural_order = true,
    },
    win_options = {
        wrap = true,
    },
}

oil.setup(config)
