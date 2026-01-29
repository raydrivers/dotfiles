local function get_python_path()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
        return venv .. "/bin/python"
    end
    return "python3"
end

return {
    filetypes = { "python" },
    settings = {
        python = {
            pythonPath = get_python_path(),
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
            },
        },
    },
    root_dir = function(fname)
        local found = vim.fs.find({
            "pyproject.toml", "setup.py", "setup.cfg",
            "requirements.txt", ".git",
        }, { upward = true, path = fname })[1]
        return found and vim.fs.dirname(found)
    end,
}