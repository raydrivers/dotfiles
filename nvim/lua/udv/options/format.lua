local filetypes = require("udv.filetypes")

local function ruff_format_buffer()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local input = table.concat(lines, "\n") .. "\n"
    local result = vim.system(
        { "ruff", "format", "--stdin-filename",
          vim.fn.expand("%:p"), "-" },
        { stdin = input }
    ):wait()
    if result.code == 0 and result.stdout then
        local new = vim.split(result.stdout, "\n")
        if new[#new] == "" then
            table.remove(new)
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, new)
    end
end

vim.keymap.set("n", "<leader>fm", function()
    local ft = vim.bo.filetype

    if ft == "python" and vim.fn.executable("ruff") == 1 then
        ruff_format_buffer()
    elseif vim.tbl_contains(filetypes.C_CPP_FILETYPES, ft)
        and vim.fn.executable("clang-format") == 1 then
        vim.lsp.buf.format({ timeout_ms = 1000 })
    else
        vim.lsp.buf.format({ timeout_ms = 1000 })
    end
end, { desc = "Format current file" })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = filetypes.C_CPP_PATTERNS,
    callback = function()
        if vim.g.format_on_save
            and vim.fn.executable("clang-format") == 1 then
            vim.lsp.buf.format({ timeout_ms = 1000 })
        end
    end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = filetypes.PYTHON_PATTERNS,
    callback = function()
        if vim.g.format_on_save
            and vim.fn.executable("ruff") == 1 then
            ruff_format_buffer()
        end
    end,
})

vim.g.format_on_save = true

vim.keymap.set("n", "<leader>tf", function()
    vim.g.format_on_save = not vim.g.format_on_save
    local status = vim.g.format_on_save and "enabled" or "disabled"
    vim.notify("Format-on-save " .. status, vim.log.levels.INFO)
end, { desc = "Toggle format-on-save" })
