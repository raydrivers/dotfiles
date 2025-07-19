local lspconfig = require("lspconfig")

local caps = vim.tbl_deep_extend(
    'force',
    vim.lsp.protocol.make_client_capabilities(),
    require('cmp_nvim_lsp').default_capabilities(),
    -- File watching is disabled by default for neovim.
    -- See: https://github.com/neovim/neovim/pull/22405
    { workspace = { didChangeWatchedFiles = { dynamicRegistration = true } } }
);

lspconfig.nil_ls.setup({
    autostart = true,
    capabilities = caps,
    cmd = { "nil" },
    settings = {
        ['nil'] = {
            formatting = {
                command = { "nixfmt" },
            },
        },
    },
})