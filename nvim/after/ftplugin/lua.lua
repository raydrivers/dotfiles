vim.keymap.set("n", "<leader>x", "<cmd>.lua<CR>", { buffer = 0, desc = "Execute current line" })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { buffer = 0, desc = "Execute current file" })

