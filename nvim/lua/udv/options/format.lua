-- Minimal format-on-save configuration

local filetypes = require("udv.filetypes")

-- Manual format shortcut
vim.keymap.set("n", "<leader>fm", function()
    local ft = vim.bo.filetype

    if ft == "python" and vim.fn.executable("ruff") == 1 then
        local file = vim.fn.expand("%:p")
        vim.system({"ruff", "format", file}):wait()
        vim.cmd("edit!")  -- Reload file
        vim.notify("Python file formatted with ruff", vim.log.levels.INFO)
    elseif vim.tbl_contains(filetypes.C_CPP_FILETYPES, ft) and vim.fn.executable("clang-format") == 1 then
        vim.lsp.buf.format({timeout_ms = 1000})
        vim.notify("C/C++ file formatted with clang-format", vim.log.levels.INFO)
    else
        vim.lsp.buf.format({timeout_ms = 1000})
    end
end, {desc = "Format current file"})

-- C/C++ formatting with clang-format
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = filetypes.C_CPP_PATTERNS,
    callback = function()
        if vim.g.format_on_save and vim.fn.executable("clang-format") == 1 then
            vim.lsp.buf.format({timeout_ms = 1000})
        end
    end,
    desc = "Format C/C++ files on save"
})

-- Python formatting with ruff
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = filetypes.PYTHON_PATTERNS,
    callback = function()
        if vim.g.format_on_save and vim.fn.executable("ruff") == 1 then
            local file = vim.fn.expand("%:p")
            vim.system({"ruff", "format", file}):wait()
        end
    end,
    desc = "Format Python files on save"
})

vim.g.format_on_save = true

vim.keymap.set("n", "<leader>tf", function()
    vim.g.format_on_save = not vim.g.format_on_save
    local status = vim.g.format_on_save and "enabled" or "disabled"
    vim.notify("Format-on-save " .. status, vim.log.levels.INFO)
end, {desc = "Toggle format-on-save"})