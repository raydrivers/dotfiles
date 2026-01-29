local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local t = ls.text_node


local function get_comment_string()
    local commentstring = vim.bo.commentstring
    if commentstring == "" then
        return "// "
    end
    return commentstring:gsub("%%s", " "):match("^(.-)%s*$") .. " "
end

local all_snippets = {
    s("date", f(function() return os.date("%Y-%m-%d") end)),

    s("time", f(function() return os.date("%H:%M:%SZ") end)),

    s("datetime", f(function() return os.date("%Y-%m-%dT%H:%M:%SZ") end)),

    s("todo", fmt("{} TODO({}): {}", {
        f(get_comment_string),
        i(1, "author"),
        i(2, "description")
    })),
}

return all_snippets
