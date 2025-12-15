-- Global filetype constants for consistent configuration

local M = {}

-- C/C++ filetypes (without dot prefix for LSP configs)
M.C_CPP_FILETYPES = {
    -- C/C++ headers
    "h", "hpp", "hxx", "hh", "h++", "hp", "hcp",
    "inl", "inc", "ipp", "ixx", "tcc", "tpp",

    -- C source
    "c", "cx", "cc",

    -- C++ source
    "cpp", "cxx", "c++", "ccp", "cp",
    "cppm", -- C++ modules

    -- Objective-C/Objective-C++
    "m",    -- Objective-C
    "mm",   -- Objective-C++

    -- CUDA
    "cu",   -- CUDA source
    "cuh",  -- CUDA headers

    -- Protocol Buffers
    "proto", -- Protocol Buffer definitions
    "pb.cc", -- Generated C++ source
    "pb.h",  -- Generated C++ headers

    -- Other extensions
    "thrift", -- Thrift definitions
    "idl",    -- Interface Definition Language files
    "x",      -- Generic extensions (rare)

    -- Preprocessed files
    "i",  -- Preprocessed source (C/C++)
    "ii", -- Preprocessed source (C++)
}

-- C/C++ filetypes with glob patterns (with asterisk for autocmd patterns)
M.C_CPP_PATTERNS = {}
for _, ext in ipairs(M.C_CPP_FILETYPES) do
    table.insert(M.C_CPP_PATTERNS, "*." .. ext)
end

-- Python filetypes
M.PYTHON_FILETYPES = {"python"}
M.PYTHON_PATTERNS = {"*.py", "*.pyi", "*.pyw"}

-- Add more languages as needed
M.RUST_FILETYPES = {"rust"}
M.RUST_PATTERNS = {"*.rs"}

M.LUA_FILETYPES = {"lua"}
M.LUA_PATTERNS = {"*.lua"}

M.NIX_FILETYPES = {"nix"}
M.NIX_PATTERNS = {"*.nix"}

return M