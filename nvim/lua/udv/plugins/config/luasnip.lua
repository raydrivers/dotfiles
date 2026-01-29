local luasnip = require("luasnip")
local luasnip_util_types = require("luasnip.util.types")
local luasnip_loaders_from_lua = require("luasnip.loaders.from_lua")

local snippets_directory_path = vim.fn.stdpath("config") .. "/lua/snippets"
local extension_base_priority = 300
local extension_priority_increase = 1

luasnip.config.set_config {
    history = true,
    updateevents = "TextChanged,TextChangedI",
    ext_base_prio = extension_base_priority,
    ext_prio_increase = extension_priority_increase,
    ext_opts = {
        [luasnip_util_types.insertNode] = {
            active = {
                hl_group = "LuaSnipActiveTabstop",
            },
        },
        [luasnip_util_types.choiceNode] = {
            active = {
                hl_group = "LuaSnipChoiceTabstop",
            },
        },
    },
    region_check_events = "CursorMoved,CursorMovedI",
    delete_check_events = "TextChanged,InsertLeave",
}

vim.api.nvim_set_hl(0, "LuaSnipActiveTabstop", {
    bg = "#3b4261",
    fg = "#ffffff",
    bold = true,
    underline = true
})
vim.api.nvim_set_hl(0, "LuaSnipUnvisitedTabstop", {
    bg = "#4a3728",
    fg = "#ffcc66",
    italic = true
})
vim.api.nvim_set_hl(0, "LuaSnipVisitedTabstop", {
    bg = "#2d3d2d",
    fg = "#a3d977"
})
vim.api.nvim_set_hl(0, "LuaSnipChoiceTabstop", {
    bg = "#4a2d4a",
    fg = "#d4a5d4",
    italic = true,
    bold = true
})
vim.api.nvim_set_hl(0, "LuaSnipExitNode", {
    bg = "#2d2d4a",
    fg = "#8080ff"
})

vim.api.nvim_set_hl(0, "LuaSnipActiveVirtText", {
    fg = "#7eb3ff",
    bold = true
})
vim.api.nvim_set_hl(0, "LuaSnipChoiceVirtText", {
    fg = "#bd93f9",
    bold = true
})
vim.api.nvim_set_hl(0, "LuaSnipExitVirtText", {
    fg = "#50fa7b",
    bold = true
})

luasnip_loaders_from_lua.load({paths = snippets_directory_path})

vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
        local completed_item = vim.v.completed_item
        if completed_item and completed_item.menu and completed_item.menu:match("%[Snippet%]") then
            if luasnip.expandable() then
                luasnip.expand()
            end
        end
    end,
})

vim.keymap.set("i", "<C-Space>", function()
    if luasnip.expandable() then
        luasnip.expand()
    end
end, { silent = true })

vim.keymap.set("n", "<leader>ds", function()
    local available_snippets = luasnip.available()
    local current_filetype = vim.bo.filetype
    local lines = { "Available snippets for " .. current_filetype .. ":" }
    for trigger, _ in pairs(available_snippets[current_filetype] or {}) do
        table.insert(lines, "  " .. trigger)
    end
    vim.notify(table.concat(lines, "\n"))
end, { desc = "Debug: Show available snippets" })

vim.keymap.set("n", "<leader>rs", function()
    luasnip_loaders_from_lua.load({paths = snippets_directory_path})
    vim.notify("Snippets reloaded")
end, { desc = "Reload snippets" })

local modes = { "i", "s" }

vim.keymap.set(modes, "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true })

vim.keymap.set(modes, "<C-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true })

vim.keymap.set(modes, "<C-l>", function()
    if luasnip.choice_active() then
        luasnip.change_choice(1)
    end
end)

vim.keymap.set(modes, "<Esc>", function()
    if luasnip.in_snippet() then
        luasnip.unlink_current()
    end
    return "<Esc>"
end, { expr = true, silent = true })

vim.keymap.set(modes, "<C-c>", function()
    if luasnip.in_snippet() then
        luasnip.unlink_current()
    end
    return "<C-c>"
end, { expr = true, silent = true })

