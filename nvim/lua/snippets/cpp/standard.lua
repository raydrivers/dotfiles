local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local standard_snippets = {
    s("method", fmt([[
auto {}::{}({}) -> {};]], { i(1, "ClassName"), i(2, "method_name"), i(3, ""), i(4, "void") })),

    s("methodi", fmt([[
auto {}::{}({}) -> {} {{
    {}
}}]], { i(1, "ClassName"), i(2, "method_name"), i(3, ""), i(4, "void"), i(5, "") })),

    s("template", fmt([[
template<{}>
auto {}({}) -> {};]], { i(1, "typename T"), i(2, "function_name"), i(3, ""), i(4, "void") })),

    s("templatei", fmt([[
template<{}>
auto {}({}) -> {} {{
    {}
}}]], { i(1, "typename T"), i(2, "function_name"), i(3, ""), i(4, "void"), i(5, "") })),

    s("lambda", fmt("[{}]({}) -> {} {{ {} }}", {
        c(1, { t(""), t("&"), t("="), t("&, =") }),
        i(2, ""), i(3, "void"), i(4, "")
    })),

    s("constexpr", fmt([[
constexpr auto {}({}) -> {};]], { i(1, "function_name"), i(2, ""), i(3, "void") })),

    s("struct", fmt([[
struct {} {{
    {}
}};]], { i(1, "StructName"), i(2, "") })),

    s("class", fmt([[
class {} {{
public:
    {}({});
    ~{}();

private:
    {}
}};]], { i(1, "ClassName"), rep(1), i(2, ""), rep(1), i(3, "") })),

    s("namespace", fmt([[
namespace {} {{
    {}
}}]], { i(1, "name"), i(2, "") })),
}

return standard_snippets
