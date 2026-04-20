return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
    },
    root_dir = function(bufnr, on_dir)
        local path = vim.api.nvim_buf_get_name(bufnr)
        local deno_root = vim.fs.find({
            "deno.json",
            "deno.jsonc",
        }, { upward = true, path = path })[1]
        if deno_root then
            return
        end

        local found = vim.fs.find({
            "tsconfig.json",
            "jsconfig.json",
            "package.json",
            ".git",
        }, { upward = true, path = path })[1]
        on_dir(found and vim.fs.dirname(found) or nil)
    end,
}
