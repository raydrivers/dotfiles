require("udv.prelude.util")

local LOAD_FIRST_PRIORITY = 1000
local LOAD_EARLY_PRIORITY = 100

local CONFIG_DIR = vim.fn.stdpath("config")
local THEMES_CONFIG_DIR = CONFIG_DIR .. "/themes"
local LOCAL_PLUGINS_DIR = CONFIG_DIR .. "/plugins"

local BASE_PLUGINS_PATH = "udv.plugins"

local plugins = {};

local function plugin_config_module_name(module_type, plugin_info)
    return BASE_PLUGINS_PATH .. '.' .. module_type .. '.' .. plugin_info.name
end

local function add_plugin(plugin_info)
    if plugin_info.disabled then
        return nil
    end

    local plugin_opts_module = plugin_config_module_name("opts", plugin_info)
    local plugin_init_module = plugin_config_module_name("init", plugin_info)
    local plugin_config_module = plugin_config_module_name("config", plugin_info)

    local plugin_generated = {
        opts = safe_require(plugin_opts_module), -- FIXME: this doesn't work for some reason
        config = function()
            safe_require(plugin_config_module)
        end,
        init = function()
            safe_require(plugin_init_module)
        end,
    }

    local plugin = vim.tbl_extend("error", plugin_info, plugin_generated)

    table.insert(plugins, plugin)

    return plugin_info
end

local function add_local_plugin(plugin_info)
    local plugin_dir = LOCAL_PLUGINS_DIR .. "/" .. plugin_info.name

    if vim.fn.isdirectory(plugin_dir) == 0 then
        error("Local plugin directory not found: " .. plugin_dir)
        return
    end

    local plugin_generated = {
        plugin_info.name,
        dir = plugin_dir,
    }

    local plugin = vim.tbl_extend('error', plugin_info, plugin_generated)

    return add_plugin(plugin)
end

---- Base plugins
add_plugin {
    "nvim-lua/plenary.nvim",
    name = "plenary",
    priority = LOAD_FIRST_PRIORITY,
    lazy = true,
}

---- Icons/UI
local nvim_web_devicons_plugin = {
    "kyazdani42/nvim-web-devicons",
}

local mini_plugin = {
    "echasnovski/mini.nvim",
    version = "*",
    config = function()
        require("udv.plugins.config.mini-pairs")
    end,
}

local vim_devicons_plugin = {
    "ryanoasis/vim-devicons",
}

local nui_plugin = {
    "MunifTanjim/nui.nvim",
}

---- Local plugins
add_local_plugin {
    name = "pcfg"
}

add_local_plugin {
    name = "regx"
}

---- Themes
local function themes_from_directory(directory)
    local themes = {}

    local uv = vim.uv
    local handle = uv.fs_scandir(directory)

    if not handle then
        error("Failed to open directory: " .. directory)
    end

    while true do
        local name, type = uv.fs_scandir_next(handle)
        if not name then
            break
        end

        if type == "directory" then
            table.insert(themes, {
                dir = directory .. "/" .. name,
                lazy = false, -- Otherwise telescope won't find them
            })
        end
    end

    return themes
end

local themes = themes_from_directory(THEMES_CONFIG_DIR)
table.insert(themes, { "ramojus/mellifluous.nvim", lazy = false })
table.insert(themes, { "RRethy/base16-nvim", lazy = false })

add_plugin {
    "rktjmp/lush.nvim",
    themes,
    name = "lush",
    priority = LOAD_FIRST_PRIORITY,
}

---- Core plugins
add_plugin {
    "folke/which-key.nvim",
    disabled = true,
    name = "whichkey",
    event = "VeryLazy",
    dependencies = {
        nvim_web_devicons_plugin,
        mini_plugin,
    },
    cond = function()
        return not vim.g.vscode
    end,
}

add_plugin {
    "ThePrimeagen/harpoon",
    name = "harpoon",
    branch = "harpoon2",
    cond = function()
        return not vim.g.vscode
    end,
}

add_plugin {
    "folke/flash.nvim",
    name = "flash",
    event = "VeryLazy",
}

local treesitter_extension_textobjects = {"nvim-treesitter/nvim-treesitter-textobjects"}
local treesitter = add_plugin {
    "nvim-treesitter/nvim-treesitter",
    name = "treesitter",
    version = false, -- It was said that last release is way too old and doesn't work on windows
    build = ":TSUpdate",
    dependencies = {
        treesitter_extension_textobjects,
    }
}

add_plugin {
    "stevearc/oil.nvim",
    name = "oil",
    dependencies = {
        nvim_web_devicons_plugin,
    },
    cond = function()
        return not vim.g.vscode
    end,
}

local telescope_extension_ui_select = add_plugin {
    "nvim-telescope/telescope-ui-select.nvim",
    name = "telescope-ui-select",
}

local telescope_extension_fzf_native = add_plugin {
    "nvim-telescope/telescope-fzf-native.nvim",
    name = "telescope-fzf-native",
    build = "make",
}

add_plugin {
    "nvim-telescope/telescope.nvim",
    name = "telescope",
    tag = "0.1.8",
    dependencies = {
        telescope_extension_ui_select,
        telescope_extension_fzf_native,
    },
    cond = function()
        return not vim.g.vscode
    end,
}

add_plugin {
    "nvim-lualine/lualine.nvim",
    name = "lualine",
    dependencies = {
        nvim_web_devicons_plugin,
        vim_devicons_plugin,
    },
    event = "VeryLazy",
    cond = function()
        return not vim.g.vscode
    end,
}

local lazydev_plugin = {
    "folke/lazydev.nvim",
    ft = "lua", -- Only load on lua files
    opts = {
        library = {{
            path = "${3rd}/luv/library",
            words = {"vim%.uv"}
        }},
    },
}

add_plugin {
    "neovim/nvim-lspconfig",
    name = "lspconfig",
    dependencies = {
        lazydev_plugin,
    }
}

add_plugin {
    'numToStr/Comment.nvim',
    name = "comment",
}

local cmp_nvim_lsp_extension = { "hrsh7th/cmp-nvim-lsp" }
local cmp_nvim_buffer_extension = { "hrsh7th/cmp-buffer" }
local cmp_nvim_path_extension = { "hrsh7th/cmp-path" }
local cmp_luasnip_extension = { "saadparwaiz1/cmp_luasnip" }

local lspkind_plugin = { "onsails/lspkind.nvim" }

local luasnip = add_plugin {
    "L3MON4D3/LuaSnip",
    name = "luasnip",
    tag = "v2.3.0",
    run = "make install jsregexp"
}

add_plugin {
    "hrsh7th/nvim-cmp",
    name = "cmp",
    lazy = false,
    priority = LOAD_EARLY_PRIORITY,
    dependencies = {
        cmp_nvim_lsp_extension,
        cmp_nvim_buffer_extension,
        cmp_nvim_path_extension,
        cmp_luasnip_extension,

        lspkind_plugin,

        luasnip,
    },
}


add_plugin {
    "folke/trouble.nvim",
    name = "trouble",
    dependencies = {
        nvim_web_devicons_plugin,
    },
    cond = function()
        return not vim.g.vscode
    end,
}

add_plugin {
    "MeanderingProgrammer/render-markdown.nvim",
    name = "render-markdown",
    dependencies = {
        mini_plugin,
        treesitter,
    },
    cond = function()
        return not vim.g.vscode
    end,
}

add_plugin {
    "lewis6991/gitsigns.nvim",
    name = "gitsigns",
}

return plugins

