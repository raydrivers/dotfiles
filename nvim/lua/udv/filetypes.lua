local M = {}

M.C_CPP_FILETYPES = { "c", "cpp", "objc", "objcpp", "cuda" }

M.C_CPP_EXTENSIONS = {
    "h", "hpp", "hxx", "hh", "h++", "hp", "hcp",
    "inl", "inc", "ipp", "ixx", "tcc", "tpp",
    "c", "cx", "cc",
    "cpp", "cxx", "c++", "ccp", "cp", "cppm",
    "m", "mm",
    "cu", "cuh",
    "proto", "pb.cc", "pb.h",
    "thrift", "idl",
    "i", "ii",
}

M.C_CPP_PATTERNS = {}
for _, ext in ipairs(M.C_CPP_EXTENSIONS) do
    table.insert(M.C_CPP_PATTERNS, "*." .. ext)
end

-- Python filetypes
M.PYTHON_FILETYPES = {"python"}
M.PYTHON_PATTERNS = {"*.py", "*.pyi", "*.pyw"}

return M
