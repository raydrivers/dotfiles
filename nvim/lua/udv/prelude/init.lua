-- Version check - require Neovim 0.10+
if vim.fn.has("nvim-0.10") == 0 then
  vim.notify("Neovim 0.10+ required. Current: " .. vim.version().minor, vim.log.levels.ERROR)
  return
end

require("udv.prelude.vimrc")
require("udv.prelude.globals")
require("udv.prelude.util")