local lspconfig = require("lspconfig")

local function on_attach(client, bufnr)
    local opts = { buffer = bufnr, remap = false, }

    local lb = vim.lsp.buf

    if client.supports_method("textDocument/rename") then
        vim.keymap.set("n", "<leader>rn", lb.rename, opts)
    end

    if client.supports_method("textDocument/implementation") then
        vim.keymap.set("n", "gi", lb.implementation, opts)
    end

    vim.keymap.set({ "n", "v" }, "<leader>ca", lb.code_action, opts)
    vim.keymap.set("n", "gd", lb.definition, opts)
    vim.keymap.set("n", "gD", lb.declaration, opts)
    vim.keymap.set("n", "gr", function()
        builtin.lsp_references()
    end, opts)
    vim.keymap.set({ "n", "i" }, "<c-p>", lb.signature_help, opts)

    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
end

-- Each LSP setup
require("udv.plugins.config.lspconfig.clangd")
require("udv.plugins.config.lspconfig.lua_ls")
require("udv.plugins.config.lspconfig.rust_analyzer")
require("udv.plugins.config.lspconfig.cmake")
require("udv.plugins.config.lspconfig.pyright")
require("udv.plugins.config.lspconfig.nil_ls")
require("udv.plugins.config.lspconfig.elixirls")

-- Events
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opts = { bufnr = ev.buf }
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        on_attach(client, opts.bufnr)
    end,
})
