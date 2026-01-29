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
            max_height = 10,
            draw = {
                gap = 2,
                padding = 1,
                columns = { { "kind_icon", "label", gap = 1 }, { "kind", "source_name" } },
            },
        },
        -- Accept behavior
        accept = {
            create_undo_point = true,
            auto_brackets = {
                enabled = true,
                default_brackets = { "(", ")" },
                override_brackets_for_filetypes = {
                    lua = { "{", "}" },
                },
                semantic_token_resolution = {
                    enabled = true,
                    timeout_ms = 400,
                },
            },
        },
    },

    -- Simplified fuzzy matching
    fuzzy = {
        sorts = { "label", "kind", "score" },
    },

    -- Disable signature help to use builtin LSP signature help
    signature = {
        enabled = false,
    },

    -- Sources configuration with priorities
    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
            snippets = {
                score_offset = 100, -- Highest priority for snippets
            },
            lsp = {
                score_offset = 50,
            },
            path = {
                score_offset = 10,
                opts = {
                    trailing_slash = false,
                    label_trailing_slash = true,
                },
            },
            buffer = {
                score_offset = 5,
            },
        },
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

})