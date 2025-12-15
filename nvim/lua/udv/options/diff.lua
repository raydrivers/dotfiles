-- Diff mode configuration

-- Enhanced diff options
vim.opt.diffopt:append({
    "algorithm:patience",  -- Better diff algorithm
    "indent-heuristic",    -- Better indentation handling
    "linematch:60",       -- Line matching for word-level diffs (nvim 0.9+)
})


-- Diff mode keymaps (only active in diff mode)
vim.api.nvim_create_autocmd("FilterWritePre", {
    callback = function()
        if vim.wo.diff then
            -- Enhanced navigation
            vim.keymap.set("n", "<leader>dg", ":diffget<CR>", {buffer = true, desc = "Diff get"})
            vim.keymap.set("n", "<leader>dp", ":diffput<CR>", {buffer = true, desc = "Diff put"})
            vim.keymap.set("n", "<leader>du", ":diffupdate<CR>", {buffer = true, desc = "Diff update"})

            -- Quick navigation
            vim.keymap.set("n", "gh", "[c", {buffer = true, desc = "Previous diff"})
            vim.keymap.set("n", "gl", "]c", {buffer = true, desc = "Next diff"})
        end
    end
})


-- Auto-enable diff when opening with nvim -d
if vim.wo.diff then
    -- Start in diff mode settings
    vim.wo.wrap = false
    vim.wo.scrollbind = true
    vim.wo.cursorbind = true
end