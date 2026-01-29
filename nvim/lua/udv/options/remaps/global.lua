-- Buffer navigation
vim.keymap.set("n", "]b", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", ":bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Session management
vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<CR>", { desc = "Save session" })
vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<CR>", { desc = "Restore session" })
vim.keymap.set("n", "<leader>sd", "<cmd>SessionDelete<CR>", { desc = "Delete session" })
vim.keymap.set("n", "<leader>sf", "<cmd>SessionSearch<CR>", { desc = "Find sessions" })
vim.keymap.set("n", "<leader>sl", "<cmd>Autosession search<CR>", { desc = "List sessions" })
