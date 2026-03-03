local function workspace_dir()
    local project = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    return vim.fn.stdpath("cache") .. "/jdtls/" .. project
end

return {
    cmd = {
        "jdtls",
        "-data", workspace_dir(),
    },
    filetypes = { "java" },
    root_markers = {
        "build.gradle",
        "build.gradle.kts",
        "pom.xml",
        "settings.gradle",
        "settings.gradle.kts",
        ".git",
    },
}
