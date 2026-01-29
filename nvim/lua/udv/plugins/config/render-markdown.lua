require('render-markdown').setup({
    latex = { enabled = false },
    html = { enabled = false },
    yaml = { enabled = false },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.treesitter.start()
    end,
})
