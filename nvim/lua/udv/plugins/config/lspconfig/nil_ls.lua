vim.lsp.config.nil_ls = {
    cmd = { "nil" },
    settings = {
        ['nil'] = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
}