require('blink.cmp').setup({
    -- Completion behavior - manual trigger only
    completion = {
        trigger = {
            show_in_snippet = false,
            show_on_keyword = false,
            show_on_trigger_character = false,
            show_on_accept_on_trigger_character = false,
        },
        documentation = {
            auto_show = false,
        },
        menu = {
            border = "rounded",
            draw = {
                gap = 2,
                columns = { { "kind_icon", "label", gap = 1 }, { "kind" } },
            },
        },
    },

    -- Disable signature help to use builtin LSP signature help
    signature = {
        enabled = false,
    },

    -- Sources configuration
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
    },

    -- Keymap configuration
    keymap = {
        preset = "default",
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-k>"] = { "snippet_forward", "fallback" },
        ["<C-j>"] = { "snippet_backward", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
    },

    -- Snippet support with LuaSnip
    snippets = {
        preset = "luasnip",
    },

    -- Appearance and behavior
    accept = {
        create_undo_point = false,
        auto_brackets = {
            enabled = true,
        },
    },
})