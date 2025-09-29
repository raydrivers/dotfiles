local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, remap = false, }

    if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    vim.keymap.set({ "n", "i" }, "<c-p>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist, opts)
end

-- Configure LSP servers
require("udv.plugins.config.lspconfig.clangd")
require("udv.plugins.config.lspconfig.lua_ls")
require("udv.plugins.config.lspconfig.rust_analyzer")
require("udv.plugins.config.lspconfig.cmake")
require("udv.plugins.config.lspconfig.pyright")
require("udv.plugins.config.lspconfig.nil_ls")
require("udv.plugins.config.lspconfig.elixirls")

-- Enable all configured LSP servers
vim.lsp.enable({
    'clangd',
    'lua_ls',
    'rust_analyzer',
    'cmake',
    'pyright',
    'nil_ls',
    'elixirls'
})

-- Events
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opts = { bufnr = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        on_attach(client, opts.bufnr)
    end,
})
