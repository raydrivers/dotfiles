-- Version check - require Neovim 0.11+
if vim.fn.has("nvim-0.11") == 0 then
  vim.notify("Neovim 0.11+ required. Current: " .. vim.version().minor, vim.log.levels.ERROR)
  return
end

local load_vimrc_cmd = "source " .. vim.fn.stdpath("config") .. "/vimrc.vim"
vim.cmd(load_vimrc_cmd)
