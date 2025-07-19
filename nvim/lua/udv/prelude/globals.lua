require("udv.prelude.util")

if is_windows() then
    vim.opt.shell = "bash.exe"
    vim.opt.shellcmdflag = "-s"
end
