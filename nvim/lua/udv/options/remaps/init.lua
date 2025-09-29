require("udv.options.remaps.global")

if not vim.g.vscode then
    require("udv.options.remaps.telescope")
    require("udv.options.remaps.windows")
    require("udv.options.remaps.oil")
else
    require("udv.options.remaps.vscode")
end

