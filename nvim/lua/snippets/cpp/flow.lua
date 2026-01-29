local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local flow_snippets = {
    s("for", fmt([[
for (const auto& {} : {}) {{
    {}
}}]], { i(1, "item"), i(2, "container"), i(3, "") })),

    s("fori", fmt([[
for (std::size_t {} = 0; {} < {}.size(); ++{}) {{
    {}
}}]], { i(1, "i"), i(2, "i"), i(3, "container"), i(4, "i"), i(5, "") })),

    s("forr", fmt([[
for (auto& {} : {}) {{
    {}
}}]], { i(1, "item"), i(2, "container"), i(3, "") })),

    s("if", fmt([[
if ({}) {{
    {}
}}]], { i(1, "condition"), i(2, "") })),

    s("elif", fmt([[
else if ({}) {{
    {}
}}]], { i(1, "condition"), i(2, "") })),

    s("else", fmt([[
else {{
    {}
}}]], { i(1, "") })),

    s("while", fmt([[
while ({}) {{
    {}
}}]], { i(1, "condition"), i(2, "") })),

    s("switch", fmt([[
switch ({}) {{
    case {}:
        {}
        break;
    default:
        {}
        break;
}}]], { i(1, "expression"), i(2, "value"), i(3, ""), i(4, "") })),

    s("try", fmt([[
try {{
    {}
}} catch (const {}& {}) {{
    {}
}}]], { i(1, ""), i(2, "std::exception"), i(3, "e"), i(4, "") })),

    s("enum", fmt([[
enum class {} {{
    {}
}};]], { i(1, "EnumName"), i(2, "") })),
}

return flow_snippets
