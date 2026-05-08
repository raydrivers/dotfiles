local LOAD_FIRST_PRIORITY = 1000

local CONFIG_DIR = vim.fn.stdpath("config")
local LOCAL_PLUGINS_DIR = CONFIG_DIR .. "/plugins"

local plugins = {};

local function add_plugin(plugin_info)
    table.insert(plugins, plugin_info)

    return plugin_info
end

local function config(name)
    return function()
        require("udv.plugins." .. name)
    end
end

local function add_local_plugin(plugin_info)
    local plugin_dir = LOCAL_PLUGINS_DIR .. "/" .. plugin_info.name

    if vim.fn.isdirectory(plugin_dir) == 0 then
        error("Local plugin directory not found: " .. plugin_dir)
    end

    local plugin_generated = {
        plugin_info.name,
        dir = plugin_dir,
    }

    local plugin = vim.tbl_extend('error', plugin_info, plugin_generated)

    return add_plugin(plugin)
end

local not_vscode = function()
    return not vim.g.vscode
end

---- Base plugins
local plenary = add_plugin {
    "nvim-lua/plenary.nvim",
    name = "plenary",
    lazy = true,
}

---- Icons/UI
local nvim_web_devicons_plugin = {
    "nvim-tree/nvim-web-devicons",
}

local mini_plugin = add_plugin {
    "nvim-mini/mini.nvim",
    version = "*",
    config = config("mini"),
}

---- Local plugins
add_local_plugin {
    name = "regx",
    config = config("regx"),
}

---- Themes
add_plugin {
    "RRethy/base16-nvim",
    name = "base16",
    lazy = false,
}

---- Core plugins
add_plugin {
    "ThePrimeagen/harpoon",
    name = "harpoon",
    branch = "harpoon2",
    config = config("harpoon"),
    dependencies = { plenary },
    cond = not_vscode,
}

add_plugin {
    "folke/flash.nvim",
    name = "flash",
    event = "VeryLazy",
    config = config("flash"),
}

local treesitter_textobjects = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
}

local treesitter = add_plugin {
    "nvim-treesitter/nvim-treesitter",
    name = "treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = config("treesitter"),
    dependencies = {
        treesitter_textobjects,
    },
}

add_plugin {
    "abecodes/tabout.nvim",
    name = "tabout",
    dependencies = { treesitter },
    event = "InsertEnter",
    config = config("tabout"),
}

add_plugin {
    "stevearc/oil.nvim",
    name = "oil",
    config = config("oil"),
    dependencies = {
        nvim_web_devicons_plugin,
    },
    cond = not_vscode,
}

local telescope_extension_ui_select = add_plugin {
    "nvim-telescope/telescope-ui-select.nvim",
    name = "telescope-ui-select",
}

local telescope_extension_fzf_native = add_plugin {
    "nvim-telescope/telescope-fzf-native.nvim",
    name = "telescope-fzf-native",
    build = (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1)
        and "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release"
        or "make",
}

add_plugin {
    "nvim-telescope/telescope.nvim",
    name = "telescope",
    branch = "master",
    config = config("telescope"),
    dependencies = {
        telescope_extension_ui_select,
        telescope_extension_fzf_native,
    },
    cond = not_vscode,
}

add_plugin {
    "nvim-lualine/lualine.nvim",
    name = "lualine",
    config = config("lualine"),
    dependencies = {
        nvim_web_devicons_plugin,
    },
    event = "VeryLazy",
    cond = not_vscode,
}

local lazydev_plugin = add_plugin {
    "folke/lazydev.nvim",
    ft = "lua", -- Only load on lua files
    opts = {
        library = {{
            path = "${3rd}/luv/library",
            words = {"vim%.uv"}
        }},
    },
}

local luasnip = add_plugin {
    "L3MON4D3/LuaSnip",
    name = "luasnip",
    config = config("luasnip"),
    build = "make install_jsregexp"
}

add_plugin {
    "MeanderingProgrammer/render-markdown.nvim",
    name = "render-markdown",
    config = config("render-markdown"),
    dependencies = {
        mini_plugin,
        treesitter,
    },
    cond = not_vscode,
}

add_plugin {
    "saghen/blink.cmp",
    name = "blink-cmp",
    config = config("blink-cmp"),
    dependencies = {
        luasnip,
        lazydev_plugin,
    },
    version = "1.*",
    cond = not_vscode,
}

add_plugin {
    "lewis6991/gitsigns.nvim",
    name = "gitsigns",
    config = config("gitsigns"),
}

add_plugin {
    "rmagatti/auto-session",
    name = "auto-session",
    config = config("auto-session"),
    cond = not_vscode,
}

return plugins
