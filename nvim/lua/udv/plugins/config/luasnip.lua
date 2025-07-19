local luasnip = require("luasnip");

luasnip.config.set_config {
    history = false,
    updateevents = "TextChanged,TextChangedI",
}

vim.keymap.set({ "i", "s", }, "<C-k>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end, { silent = true, })

vim.keymap.set({ "i", "s", }, "<C-k>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end, { silent = true, })

