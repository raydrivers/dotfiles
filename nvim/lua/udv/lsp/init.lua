vim.lsp.enable({
    'clangd',
    'lua_ls',
    'rust_analyzer',
    'cmake',
    'pyright',
    'elixirls'
})

vim.diagnostic.config({
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
})


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then
            return
        end

        if client.supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end


        local opts = { buffer = bufnr }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set({ "n", "i" }, "<C-p>", vim.lsp.buf.signature_help, opts)

        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>dq", vim.diagnostic.setqflist, opts)
        vim.keymap.set("n", "<C-l>", function()
            vim.diagnostic.setloclist()
            vim.cmd("lopen")
        end, opts)
    end,
})
