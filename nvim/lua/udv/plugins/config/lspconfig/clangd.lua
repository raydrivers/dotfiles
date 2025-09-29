vim.lsp.config.clangd = {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--enable-config",
        "--cross-file-rename",
        -- "--function-arg-placeholders",
        "--all-scopes-completion",
        "--header-insertion=iwyu",
        "--completion-style=bundled"
    },
    filetypes = {
        -- C/C++ headers
        "h",
        "hpp",
        "hxx",
        "hh",
        "h++",
        "inl",
        "inc",
        "ipp",
        "tcc",
    
        -- C source
        "c",
        "cx",
        "cc",
    
        -- C++ source
        "cpp",
        "cxx",
        "c++",
        "ccp",
        "cppm", -- C++ modules
    
        -- Objective-C/Objective-C++
        "m",    -- Objective-C
        "mm",   -- Objective-C++
    
        -- CUDA
        "cu",   -- CUDA source
        "cuh",  -- CUDA headers
    
        -- Protocol Buffers (Proto/gRPC)
        "proto", -- Protocol Buffer definitions
        "pb.cc", -- Generated C++ source
        "pb.h",  -- Generated C++ headers
    
        -- Other extensions (e.g., custom tooling)
        "thrift", -- Thrift definitions (if applicable)
        "idl",    -- Interface Definition Language files
        "x",      -- Generic Objective-C extensions (rare)
    
        -- Miscellaneous
        "i",  -- Preprocessed source (C/C++)
        "ii", -- Preprocessed source (C++)
    },    
    capabilities = {
        offsetEncoding = { "utf-8", "utf-16" },
    },
}

vim.keymap.set(
    "n",
    "<leader>sh",
    ":ClangdSwitchSourceHeader<CR>",
    { desc = "Switch to corresponding C/C++ header/source file" }
)

vim.keymap.set(
    "n",
    "<leader>ssi",
    ":ClangdShowSymbolInfo<CR>",
    { desc = "Show symbol info" }
)
