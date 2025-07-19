local neotree = require("neo-tree")

local function go_to_parent(state)
    local fs = require("neo-tree.sources.filesystem")

    local node = state.tree:get_node()
    print(vim.inspect(node))

    local parent_node = node:get_parent_id()

    if parent_node == nil then
        return
    end

    local path = state.tree:get_node(parent_node):get_id()
    fs.navigate(state, state.path, path)
end

neotree.setup {
    -- popup_border_style = "double",

    enable_git_status = true,
    default_component_configs = {
        container = {
            enable_character_fade = true,
        },
        indent = {
            indent_size = 2,
            padding = 1,
        },
        icon = {
            highlight = "NeoTreeFileIcon",
        },
        name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName"
        },
        git_status = {
            symbols = {
                -- Change type
                added     = "+",
                modified  = "~",
                deleted   = "-",
                renamed   = "R",
                -- Status type
                untracked = "?",
                ignored   = "!",
                unstaged  = "U",
                staged    = "S",
                conflict  = "X"
            }
        },
        file_size = {
            enabled = true,
            width = 4,
            required_width = 72,
        },
    },
    commands = {
        ["go_to_parent"] = go_to_parent
    },
    window = {
        position = "right",
        width = 48,
        mappings = {
            ["<cr>"] = "open_with_window_picker",
            ["v"] = "vsplit_with_window_picker",
            ["s"] = "split_with_window_picker",
            ["K"] = "go_to_parent"
        }
    },
    filesystem = {
        follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
        },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        filtered_items = {
            visible = false,
            hide_dotfiles = true,
            hide_gitignored = false,
            hide_hidden = false,
            
            hide_by_name = {},
            hide_by_pattern = {},
            always_show = {},
            always_show_by_pattern = {},
            never_show = {
                ".DS_Store",
            },
            never_show_by_pattern = {},
        },
    },
}
