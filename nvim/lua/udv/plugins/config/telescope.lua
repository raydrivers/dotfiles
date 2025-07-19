
local telescope = require("telescope")
local actions = require("telescope.actions")

local config = {
    -- defaults = {
    --     -- TODO: vimgrep_arguments
    --     path_display = { "truncate" },
    --     theme = "dropdown",
    -- },
    defaults = {},
    pickers = {
        find_files = {
            theme = "dropdown",
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case"
        }
    },
}

telescope.setup(config)

-- Extensions
telescope.load_extension("ui-select")