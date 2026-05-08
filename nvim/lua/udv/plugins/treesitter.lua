vim.env.CC = "cc -O2"

local parsers = {
    "asm", "awk", "c", "cpp", "objc", "perl",
    "cmake", "make", "cuda", "go", "vim", "vimdoc",
    "json", "bash", "python", "html", "css",
    "javascript", "typescript", "tsx", "php",
    "doxygen", "glsl", "hlsl",
    "java", "kotlin", "nix", "sql", "yaml", "toml",
    "zig", "rust", "lua", "luadoc",
    "markdown", "markdown_inline", "gn",
}

local ts = require("nvim-treesitter")

ts.setup {
    install_dir = vim.fn.stdpath("data") .. "/site",
}

-- Replacement for old ensure_installed/auto_install on main branch.
ts.install(parsers)

vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        if not pcall(vim.treesitter.start, ev.buf) then
            return
        end

        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

require("nvim-treesitter-textobjects").setup {
    select = {
        lookahead = true,
    },
}

local ts_select = require("nvim-treesitter-textobjects.select")

local function textobj(keys, query, group)
    vim.keymap.set({ "x", "o" }, keys, function()
        ts_select.select_textobject(query, group or "textobjects")
    end, {
        desc = "Select " .. query,
    })
end

textobj("af", "@function.outer")
textobj("if", "@function.inner")
textobj("ac", "@class.outer")
textobj("ic", "@class.inner")
textobj("as", "@scope", "locals")
