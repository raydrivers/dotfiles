vim.opt.background = 'dark'
vim.g.colors_name = 'aesthetic_dark'

local MODULE_NAME = "udv.aesthetic_dark.theme"
package.loaded[MODULE_NAME] = nil

require("lush")(require(MODULE_NAME))
