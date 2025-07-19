local lspkind = require("lspkind")
local luasnip = require("luasnip")

local lspkind_config = {
    mode = "symbol_text",
    preset = "codicons",
    menu = ({
        buffer        = "[Buffer]",
        nvim_lsp      = "[LSP]",
        luasnip       = "[LuaSnip]",
        nvim_lua      = "[Lua]",
        latex_symbols = "[Latex]",
    }),
    maxwidth = {
        -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        -- can also be a function to dynamically calculate max width such as
        -- menu = function() return math.floor(0.45 * vim.o.columns) end,
        menu = 48, -- leading text (labelDetails)
        abbr = 48, -- actual suggestion item
    },
    ellipsis_char = '...',
    show_labelDetails = true, -- show labelDetails in menu. Disabled by default
    -- The function below will be called before any actual modifications from lspkind
    -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
    before = function (entry, vim_item)
        -- ...
        return vim_item
    end,
}

local cmp = require("cmp")

local cmp_config = {
    formatting = {
        format = lspkind.cmp_format(lspkind_config),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer" },
    },
    -- view = {},

    -- TODO: should these mappings be here?
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            },
            { "i", "c", }
        ),

        ["<C-Space>"] = cmp.mapping.complete(),
    },

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
}

cmp.setup(cmp_config)

