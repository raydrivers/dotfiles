local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

-- Helper function to get filename without extension
local function get_filename()
    return vim.fn.expand("%:t:r")
end

-- C++ specific snippets
local cpp_snippets = {
    s("main", {
        t({"#include <iostream>", "", "int main() {", "    "}),
        i(1, "/* TODO: implement */"),
        t({"", "    return 0;", "}"}),
    }),

    s("inc", {
        t("#include <"),
        i(1, "iostream"),
        t(">"),
    }),

    s("incs", {
        t("#include \""),
        i(1, "header.h"),
        t("\""),
    }),

    s("for", {
        t("for ("),
        i(1, "int i = 0"),
        t("; "),
        i(2, "i < n"),
        t("; "),
        i(3, "++i"),
        t({") {", "    "}),
        i(4, "// loop body"),
        t({"", "}"}),
    }),

    s("class", {
        t("class "),
        i(1, "ClassName"),
        t({" {", "public:", "    "}),
        f(function(args) return args[1][1] .. "()" end, {1}),
        t({";", "    ~"}),
        f(function(args) return args[1][1] .. "()" end, {1}),
        t({";", "", "private:", "    "}),
        i(2, "// private members"),
        t({"", "};"})
    }),

    s("cout", {
        t("std::cout << "),
        i(1, "\"Hello World\""),
        t(" << std::endl;"),
    }),

    s("if", {
        t("if ("),
        i(1, "condition"),
        t({") {", "    "}),
        i(2, "// if true"),
        t({"", "}"}),
    }),

    s("func", {
        i(1, "void"),
        t(" "),
        i(2, "functionName"),
        t("("),
        i(3, "/* parameters */"),
        t({") {", "    "}),
        i(4, "// function body"),
        t({"", "}"}),
    }),
}

-- Return snippets for lua loader
return cpp_snippets