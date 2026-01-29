local ok = pcall(vim.cmd, "colorscheme base16-tomorrow-night")
if not ok then
    vim.cmd("colorscheme default")
end
