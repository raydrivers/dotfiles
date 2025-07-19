local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
    filetypes = { "python" },
})

