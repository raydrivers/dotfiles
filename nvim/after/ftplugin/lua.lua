vim.api.nvim_buf_set_keymap(0, "n", "<leader>x", "<cmd>.lua<CR>", { desc = "Execute current line" })
vim.api.nvim_buf_set_keymap(0, "n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute current file" })

