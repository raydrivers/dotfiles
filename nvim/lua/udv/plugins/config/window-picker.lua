local window_picker = require("window-picker")

local config = {
    hint = "floating-big-letter",
    selection_chars = 'FJDKSLA;CMRUEIWOQP',
    picker_config = {
        floating_big_letter = {
            font = 'ansi-shadow',
        },
    },
    show_prompt = false,
    filter_rules = {
        include_current_win = false,
        autoselect_one = true,
        -- filter using buffer options
        bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = {"neo-tree", "neo-tree-popup", "notify"},
            -- if the buffer type is one of following, the window will be ignored
            buftype = {"terminal", "quickfix"},
        },
    },
}

window_picker.setup(config)