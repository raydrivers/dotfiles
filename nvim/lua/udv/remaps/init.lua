require("udv.remaps.global")

if vim.g.vscode then
    require("udv.remaps.vscode")
else
    require("udv.remaps.telescope")
    require("udv.remaps.windows")
    require("udv.remaps.oil")
end
