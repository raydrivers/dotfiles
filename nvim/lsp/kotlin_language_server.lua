return {
    cmd = { "kotlin-language-server" },
    cmd_env = {
        JAVA_OPTS = "-Xmx2g -XX:+UseG1GC",
    },
    filetypes = { "kotlin" },
    root_markers = {
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "settings.gradle.kts",
        "pom.xml",
        ".git",
    },
}
