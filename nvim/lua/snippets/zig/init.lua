local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local zig_snippets = {
    s("_", fmt("_ = {};", { i(1, "value") })),
}

return zig_snippets
