-- Thanks overflown for this snippet https://github.com/integer-overflown/nvim-config/blob/main/lua/config/spellcheck.lua

local function make_ignore_map(filetypes)
    local ret = {}

    for _, value in ipairs(filetypes) do
        ret[value] = true
    end

    return ret
end

local ignored = make_ignore_map({
    "TelescopePrompt",
    "TelescopePromptBorder",
    "TelescopeResults",
    "dashboard",
    "neo-tree",
    "neo-tree-popup",
    "notify",
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable spell-check for editable buffers",
    group = vim.api.nvim_create_augroup("ovf-buf-spellcheck", { clear = true }),
    callback = function(args)
        local filetype = args.match

        if ignored[filetype] then
            return
        end

        local win = vim.api.nvim_get_current_win()
        vim.wo[win].spell = true
        vim.bo[args.buf].spelllang = "en_us"
    end,
})
