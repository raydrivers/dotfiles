local telescope = require("telescope")
local themes = require("telescope.themes")

local config = {
    defaults = themes.get_ivy {
        path_display = { "truncate" },
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

telescope.load_extension("ui-select")
telescope.load_extension("fzf")

