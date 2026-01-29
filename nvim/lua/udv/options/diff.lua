vim.opt.diffopt:append({
    "algorithm:patience",
    "indent-heuristic",
    "linematch:60",
})

local function setup_diff_keymaps()
    local opts = { buffer = true }
    vim.keymap.set("n", "<leader>dg", ":diffget<CR>", opts)
    vim.keymap.set("n", "<leader>dp", ":diffput<CR>", opts)
    vim.keymap.set("n", "<leader>du", ":diffupdate<CR>", opts)
    vim.keymap.set("n", "gh", "[c", opts)
    vim.keymap.set("n", "gl", "]c", opts)
end

vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "diff",
    callback = function()
        if vim.wo.diff then
            setup_diff_keymaps()
        end
    end,
})

if vim.wo.diff then
    setup_diff_keymaps()
    vim.wo.wrap = false
    vim.wo.scrollbind = true
    vim.wo.cursorbind = true
end
