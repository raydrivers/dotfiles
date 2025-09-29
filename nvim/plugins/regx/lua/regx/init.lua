---@class regx
---@field patterns Pattern[]
local regx = {}
regx.__index = regx

---@class Pattern
---@field name string pattern name
---@field match string regex string to match
---@field url string base URL
regx.patterns = {}

local function get_open_cmd(url)
    local sysname = vim.uv.os_uname().sysname

    if sysname == "Darwin" then
        return { "open", url}
    elseif sysname == "Linux" then
        return { "xdg-open", url }
    elseif sysname == "Windows_NT" then
        return { "cmd.exe", "/c", "start", url }
    end
end

function regx:match(pattern, word)
    if type(pattern.match) == "function" then
        return pattern.match(word)
    elseif type(pattern.match) == "string" then
        return word:match(pattern.match)
    end
end

function regx:open_link(word)
    for _, pattern in ipairs(self.patterns) do
        local match = self:match(pattern, word)
        if match then
            local full_url = pattern.url .. match
            vim.fn.system(get_open_cmd(full_url))
            return
        end
    end

    vim.api.nvim_feedkeys("gx", "n", false)
end

function regx:open_current_word()
    local word = vim.fn.expand("<cWORD>")
    if word and word ~= "" then
        self:open_link(word)
    end
end

--- Adds new matcher
---@param pattern Pattern
function regx:add(pattern)
    table.insert(self.patterns, pattern)
end

function regx:setup()
    vim.keymap.set("n", "gx", function() self:open_current_word() end, { noremap = true, silent = true })
end

return regx

