local parsers = {
    "asm", "awk", "c", "cpp", "objc", "perl",
    "cmake", "make", "cuda", "go", "vim", "vimdoc",
    "json", "bash", "python", "html", "css",
    "javascript", "php", "doxygen", "glsl", "hlsl",
    "java", "kotlin", "nix", "sql", "yaml", "toml",
    "zig", "rust", "lua", "luadoc",
    "markdown", "markdown_inline",
}

require("nvim-treesitter").setup({
    ensure_installed = parsers,
    auto_install = true,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr =
                "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

local ts_select = require("nvim-treesitter-textobjects.select")
local obj_modes = { "x", "o" }

local function textobj(keys, query, group)
    group = group or "textobjects"
    vim.keymap.set(obj_modes, keys, function()
        ts_select.select_textobject(query, group)
    end)
end

textobj("af", "@function.outer")
textobj("if", "@function.inner")
textobj("ac", "@class.outer")
textobj("ic", "@class.inner")
textobj("as", "@scope", "locals")
