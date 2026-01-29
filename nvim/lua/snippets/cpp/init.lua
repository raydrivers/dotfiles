local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local init_snippets = {
    s("func", fmt([[
auto {}({}) -> {} {{
    {}
}}]], { i(1, "function_name"), i(2, ""), i(3, "void"), i(4, "") })),

    s("funcold", fmt([[
{} {}({}) {{
    {}
}}]], { i(1, "return_type"), i(2, "function_name"), i(3, ""), i(4, "") })),

    s("auto", fmt("auto {} = {};", { i(1, "variable_name"), i(2, "value") })),

    s("main", fmt([[
#include <iostream>

int main() {{
    {}
    return 0;
}}]], { i(1, "") })),

    s("inc", fmt("#include <{}>", { i(1, "iostream") })),

    s("inp", fmt("#include \"{}\"", { i(1, "header.h") })),
}

local standard_snippets = require("snippets.cpp.standard")
local stl_snippets = require("snippets.cpp.stl")
local flow_snippets = require("snippets.cpp.flow")

local all_cpp_snippets = {}
vim.list_extend(all_cpp_snippets, init_snippets)
vim.list_extend(all_cpp_snippets, standard_snippets)
vim.list_extend(all_cpp_snippets, stl_snippets)
vim.list_extend(all_cpp_snippets, flow_snippets)

return all_cpp_snippets