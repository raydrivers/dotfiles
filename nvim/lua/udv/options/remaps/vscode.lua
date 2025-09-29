if not vim.g.vscode then
    return
end

local vscode = require('vscode-neovim')

-- File operations
vim.keymap.set('n', '<leader>ff', function()
    vscode.call('workbench.action.quickOpen')
end, { desc = "Find - Files" })

vim.keymap.set('n', '<leader>fg', function()
    vscode.call('workbench.action.findInFiles')
end, { desc = "Find - Grep" })

vim.keymap.set('n', '<leader>fb', function()
    vscode.call('workbench.action.showAllEditors')
end, { desc = "Find - Buffers" })

vim.keymap.set('n', '<leader>fs', function()
    vscode.call('workbench.action.gotoSymbol')
end, { desc = "Find - Symbols" })

vim.keymap.set('n', '<leader>fs', function()
    vscode.call('workbench.action.showAllSymbols')
end, { desc = "Find - Workspace Symbols" })

vim.keymap.set('n', '<leader>fr', function()
    vscode.call('workbench.action.openRecent')
end, { desc = "Find - Recent" })

vim.keymap.set('n', '<leader>fk', function()
    vscode.call('workbench.action.openGlobalKeybindings')
end, { desc = "Find - Keymaps" })

-- Git operations
vim.keymap.set('n', '<leader>vb', function()
    vscode.call('git.checkout')
end, { desc = "VCS - Branches" })

vim.keymap.set('n', '<leader>vc', function()
    vscode.call('git.viewHistory')
end, { desc = "VCS - Commits" })

-- Config editing (open settings)
vim.keymap.set('n', '<leader>ec', function()
    vscode.call('workbench.action.openSettings')
end, { desc = "Edit Config" })
