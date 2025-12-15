local filetypes = require("udv.filetypes")

return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--enable-config",
        "--cross-file-rename",
        "--all-scopes-completion",
        "--header-insertion=iwyu",
        "--completion-style=bundled"
    },
    filetypes = filetypes.C_CPP_FILETYPES,
    capabilities = {
        offsetEncoding = { "utf-8", "utf-16" },
    },
    on_attach = function(client, bufnr)
        vim.keymap.set("n", "<leader>sh", ":ClangdSwitchSourceHeader<CR>",
            { buffer = bufnr, desc = "Switch to corresponding C/C++ header/source file" })
        vim.keymap.set("n", "<leader>ssi", ":ClangdShowSymbolInfo<CR>",
            { buffer = bufnr, desc = "Show symbol info" })
    end,
}