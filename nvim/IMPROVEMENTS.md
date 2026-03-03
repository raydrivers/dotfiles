# Neovim Configuration Guide

## Overview
- **Neovim Version**: 0.11+ required (modern LSP features)
- **Philosophy**: Non-bloat, portable, efficient workflow
- **LSP**: Native Neovim 0.11 LSP with clangd, pyright, etc.
- **Completion**: blink.cmp with LuaSnip integration (manual trigger)

## Complete Hotkey Reference

### File Management
- `<leader>ff` → Find files (Telescope)
- `<leader>fg` → Live grep search
- `<leader>fb` → Open buffers
- `<leader>ec` → Edit config files
- `]b` / `[b` → Next/previous buffer
- `<leader>bd` → Delete buffer
- `<leader>w` → Save file (only if changed)

### LSP (Code Intelligence)
- `gd` → Go to definition
- `gD` → Go to declaration
- `K` → Hover documentation
- `grn` → Rename symbol (0.11 built-in)
- `gra` → Code actions (0.11 built-in)
- `gri` → Go to implementation (0.11 built-in)
- `grr` → Find references (0.11 built-in)
- `<Ctrl-p>` → Signature help (insert/normal mode)
- `<Ctrl-s>` → Signature help cycling (0.11 built-in)

### Diagnostics & Error Navigation
- `]d` / `[d` → Next/previous diagnostic
- `<leader>e` → Show diagnostic popup (rounded border)
- `<Ctrl-l>` → Current file diagnostics → location list
- `<leader>dq` → All LSP diagnostics → quickfix

### Quickfix & Location Lists
**Quickfix Navigation:**
- `<leader>j` → Next quickfix item
- `<leader>k` → Previous quickfix item
- `<leader>q` → Open quickfix window
- `<Ctrl-q>` → Close quickfix window
- `:cc` → Go to current error
- `:cnext` / `:cprev` → Navigate items
- `:cfirst` / `:clast` → First/last item

**Location Lists:**
- `<leader>J` → Next location list item
- `<leader>K` → Previous location list item
- `:lopen` → Open location window
- `:lclose` → Close location window
- `:lnext` / `:lprev` → Navigate items

### Code Editing & Formatting
- `gc` → Comment/uncomment line (native 0.10+)
- `gb` → Block comment (native 0.10+)
- `<leader>fm` → Format current file
- `<leader>tf` → Toggle format-on-save
- `J` → Join lines (cursor stays in place)
- `<leader>d` → Delete to black hole register
- `<leader>y` / `<leader>Y` → Copy to system clipboard
- `<leader>p` / `<leader>P` → Paste from system clipboard

### Completion & Snippets (blink.cmp + LuaSnip)
- `<C-Space>` → Trigger completion menu
- `<C-e>` → Hide completion menu
- `<CR>` → Accept completion
- `<C-n>` / `<C-p>` → Navigate completion items
- `<C-k>` / `<C-j>` → Navigate snippet tabstops
- `<C-l>` → Cycle through snippet choices
- `<Esc>` / `<C-c>` → Exit snippet mode
- `<leader>rs` → Reload snippets
- `<leader>ds` → Show available snippets for current filetype

### Search & Replace
- `<leader>s` → Search/replace current word
- `;;` → Search/replace pattern `::%s::g`
- `;'` → Search/replace with confirmation `::%s::gc`
- `n` / `N` → Next/prev search (cursor centered)
- `<Ctrl-;>` → Clear search highlights

### Advanced Navigation
- `<leader>fs` → Document symbols (Telescope)
- `<leader>fS` → Workspace symbols (Telescope)
- `<leader>fh` → Help tags
- `<leader>fk` → Keymaps
- `<Ctrl-d>` / `<Ctrl-u>` → Scroll (cursor centered)
- `<Tab>` → Toggle relative line numbers

### Visual Mode Enhancements
- `J` / `K` → Move selected lines up/down
- `<leader>p` → Paste without yanking selection
- `<leader>y` → Copy selection to system clipboard

### Git Integration
- `<leader>vb` → Git branches (Telescope)
- `<leader>vc` → Git commits (Telescope)

**Git Difftool Mode:** (`nvim -d file1 file2`)
- `<leader>dg` → Diff get (obtain from other file)
- `<leader>dp` → Diff put (send to other file)
- `<leader>du` → Diff update
- `gh` / `gl` → Previous/next diff
- `]c` / `[c` → Next/prev change (built-in)


### Window Management
- `<Left/Down/Up/Right>` → Navigate windows
- `:split` / `:vsplit` → Create splits
- `:only` → Close all other windows

### Oil.nvim (File Explorer)
- Opens automatically for directories
- Navigate like normal buffer
- `<CR>` → Enter directory/open file

### Additional Hotkeys
**Utility:**
- `,p` / `,P` → Paste last yanked (not current)
- `Q` → Disabled (no-op)
- `<Tab>` → Toggle relative line numbers

**Clangd Specific:**
- `<leader>sh` → Switch header/source
- `<leader>ssi` → Show symbol info

## Quickfix & Location Lists Guide

### Understanding the Difference
- **Quickfix**: Global error list (shared across all windows)
- **Location List**: Per-window error list (local to current window)

### Common Quickfix Workflows

**Compiler Errors:**
```
:make                  " Run make command
:copen                 " View errors in quickfix
<leader>j/k            " Navigate errors
:cc                    " Jump to current error
```

**Search Results:**
```
:grep pattern **/*.py  " Search across files
:copen                 " View results
<leader>j/k            " Navigate matches
```

**LSP Diagnostics:**
```
<leader>dq             " Load all LSP errors
<leader>q              " Open quickfix window
<leader>j/k            " Navigate problems
```

**External Tools:**
```
:cgetexpr system('ruff check . --output-format=concise')
:copen                 " View linter results
```

### Location List Workflows

**Current File Focus:**
```
<Ctrl-l>               " Current file diagnostics → location list
:lopen                 " View in location window
<leader>J/K            " Navigate within file
```

### Advanced Quickfix Tips
- `:cdo %s/old/new/g` → Search/replace across all quickfix files
- `:cfdo %s/old/new/g` → Search/replace in each quickfix file
- `:chistory` → View quickfix history
- `:colder` / `:cnewer` → Navigate quickfix history

## Language-Specific Features

### C/C++ Development
- **LSP**: clangd with clang-tidy integration
- **Filetypes**: All C/C++ extensions (40+) including .inl, .cu, .proto
- **Formatting**: clang-format on save
- **Switch header/source**: `<leader>sh`
- **Snippets**: Modern C++ with trailing return types (func, method, template, lambda, etc.)
- **Project snippets**: Place in `<project>/.nvim/snippets/cpp/` for project-specific patterns

### Python Development
- **LSP**: pyright with virtual environment detection
- **Formatting**: ruff on save
- **Filetypes**: .py, .pyi, .pyw

## Configuration Structure
```
lua/udv/
├── filetypes.lua            # Global filetype constants
├── lsp/
│   └── init.lua             # Modern 0.11 LSP setup
├── options/
│   ├── diff.lua             # Git difftool setup
│   ├── format.lua           # Auto-formatting
│   └── remaps/              # Key mappings
└── plugins/
    └── config/              # Plugin configurations
lsp/                         # LSP server configs (0.11 style)
├── clangd.lua
├── pyright.lua
└── ...
```

## Outstanding TODOs
1. **Git difftool --dir-diff** - Open all files simultaneously
2. **Build shortcuts** - pcfg integration
3. **Project-wide diagnostics** - External tools for unopened files
4. **EditorConfig** - Add to projects for consistency

## IDE Enhancement Roadmap
*Priority plan to replace CLion/VSCode for daily development*

### High Priority
1. **Testing Integration** - Add neotest for running tests inline with results visualization
2. **Grep-Replace Enhancement** - Enhance telescope with better project-wide search/replace capabilities
3. **Quickfix Build Integration** - Properly collect build errors in quickfix list from pcfg builds

### Medium Priority
4. **External Linting** - Add nvim-lint with tools like cppcheck, clang-tidy, flake8, mypy, shellcheck for additional code quality analysis beyond LSP
