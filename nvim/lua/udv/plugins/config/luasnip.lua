local luasnip = require("luasnip");

luasnip.config.set_config {
    history = false,
    updateevents = "TextChanged,TextChangedI",
    -- Show ALL snippet nodes simultaneously for full context
    ext_base_prio = 300,
    ext_prio_increase = 1,
    ext_opts = {
        [require("luasnip.util.types").insertNode] = {
            active = {
                -- Blue background with bold text for CURRENT active tabstop
                hl_group = "LuaSnipActiveTabstop",
                virt_text = { { " ACTIVE ", "LuaSnipActiveVirtText" } },
                virt_text_pos = "right_align",
            },
            passive = {
                -- Highlight ALL linked instances of the same variable
                hl_group = "LuaSnipLinkedTabstop",
                virt_text = { { " LINKED ", "LuaSnipLinkedVirtText" } },
                virt_text_pos = "right_align",
            },
            unvisited = {
                -- Orange background for unvisited tabstops (ALWAYS visible)
                hl_group = "LuaSnipUnvisitedTabstop",
            },
            visited = {
                -- Green background for visited tabstops (ALWAYS visible)
                hl_group = "LuaSnipVisitedTabstop",
            },
        },
        [require("luasnip.util.types").choiceNode] = {
            active = {
                -- Purple background for choice nodes
                hl_group = "LuaSnipChoiceTabstop",
                virt_text = { { " CHOICE ", "LuaSnipChoiceVirtText" } },
                virt_text_pos = "right_align",
            },
            unvisited = {
                hl_group = "LuaSnipChoiceTabstop",
            },
        },
        [require("luasnip.util.types").exitNode] = {
            unvisited = {
                -- Mark the exit point of snippet
                hl_group = "LuaSnipExitNode",
                virt_text = { { " EXIT ", "LuaSnipExitVirtText" } },
                virt_text_pos = "eol",
            },
        },
    },
    -- Enhanced region checking to show snippet boundaries
    region_check_events = "CursorMoved,CursorMovedI",
    delete_check_events = "TextChanged,InsertLeave",
}

-- Define custom highlight groups for IDE-like appearance
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

-- Virtual text indicators
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

-- Load snippets from lua/snippets directory
require("luasnip.loaders.from_lua").load({paths = vim.fn.stdpath("config") .. "/lua/snippets"})

-- Integrate snippets with built-in completion
vim.api.nvim_create_autocmd("CompleteDone", {
    callback = function()
        local completed_item = vim.v.completed_item
        -- Check if completed item is a snippet
        if completed_item and completed_item.menu and completed_item.menu:match("%[Snippet%]") then
            -- Try to expand the snippet
            local luasnip = require("luasnip")
            if luasnip.expandable() then
                luasnip.expand()
            end
        end
    end,
})

-- Manual trigger for testing
vim.keymap.set("i", "<C-Space>", function()
    if luasnip.expandable() then
        luasnip.expand()
    end
end, { silent = true })

-- Debug function to check available snippets
vim.keymap.set("n", "<leader>ds", function()
    local available = luasnip.available()
    print("Available snippets for " .. vim.bo.filetype .. ":")
    for trigger, _ in pairs(available[vim.bo.filetype] or {}) do
        print("  " .. trigger)
    end
end, { desc = "Debug: Show available snippets" })

vim.keymap.set({ "i", "s", }, "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true, })

vim.keymap.set({ "i", "s", }, "<C-j>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true, })

-- Escape/cancel snippet
vim.keymap.set({ "i", "s" }, "<Esc>", function()
    if luasnip.in_snippet() then
        luasnip.unlink_current()
        return "<Esc>"
    else
        return "<Esc>"
    end
end, { expr = true, silent = true })

-- Alternative cancel with Ctrl+C
vim.keymap.set({ "i", "s" }, "<C-c>", function()
    if luasnip.in_snippet() then
        luasnip.unlink_current()
    end
    return "<C-c>"
end, { expr = true, silent = true })

