require('blink.cmp').setup({
    completion = {
        trigger = {
            show_in_snippet = false,
            show_on_keyword = true,
            show_on_trigger_character = true,
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
                columns = {
                    { "kind_icon", "label", gap = 1 },
                    { "kind", "source_name" },
                },
            },
        },
        accept = {
            create_undo_point = true,
            auto_brackets = { enabled = true },
        },
    },

    fuzzy = {
        sorts = { "score", "sort_text" },
    },

    signature = { enabled = false },

    sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
            snippets = { score_offset = 100 },
            lsp = { score_offset = 50 },
            path = { score_offset = 10 },
            buffer = { score_offset = 5 },
        },
    },

    keymap = {
        preset = "default",
        ["<C-Space>"] = { "show" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-y>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-k>"] = { "snippet_forward", "fallback" },
        ["<C-j>"] = { "snippet_backward", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
    },

    snippets = { preset = "luasnip" },
})
