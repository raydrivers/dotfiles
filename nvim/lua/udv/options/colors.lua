local ok = pcall(vim.cmd, "colorscheme base16-tomorrow-night")
if not ok then
    vim.cmd("colorscheme default")
    return
end

-- base16-tomorrow-night maps Identifier/variables to
-- base08 (#cc6666, red). Override to base05 (foreground
-- white) to reduce red dominance.
local fg = "#c5c8c6"
vim.api.nvim_set_hl(0, "Identifier", { fg = fg })
vim.api.nvim_set_hl(0, "@variable", { fg = fg })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg = fg })
