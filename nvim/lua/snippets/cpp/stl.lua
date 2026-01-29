local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local stl_snippets = {
    s("vector", fmt("std::vector<{}> {};", { i(1, "int"), i(2, "vec") })),

    s("map", fmt("std::map<{}, {}> {};", { i(1, "std::string"), i(2, "int"), i(3, "map") })),

    s("unordered_map", fmt("std::unordered_map<{}, {}> {};", { i(1, "std::string"), i(2, "int"), i(3, "umap") })),

    s("set", fmt("std::set<{}> {};", { i(1, "int"), i(2, "set") })),

    s("unordered_set", fmt("std::unordered_set<{}> {};", { i(1, "int"), i(2, "uset") })),

    s("pair", fmt("std::pair<{}, {}> {};", { i(1, "int"), i(2, "int"), i(3, "pair") })),

    s("string", fmt("std::string {};", { i(1, "str") })),

    s("array", fmt("std::array<{}, {}> {};", { i(1, "int"), i(2, "10"), i(3, "arr") })),

    s("unique", fmt("std::unique_ptr<{}> {};", { i(1, "int"), i(2, "ptr") })),

    s("shared", fmt("std::shared_ptr<{}> {};", { i(1, "int"), i(2, "ptr") })),

    s("make_unique", fmt("std::make_unique<{}>({});", { i(1, "Type"), i(2, "") })),

    s("make_shared", fmt("std::make_shared<{}>({});", { i(1, "Type"), i(2, "") })),

    s("cout", fmt("std::cout << {} << std::endl;", { i(1, "\"Hello World\"") })),

    s("cin", fmt("std::cin >> {};", { i(1, "variable") })),

    s("optional", fmt("std::optional<{}> {};", { i(1, "int"), i(2, "opt") })),
}

return stl_snippets