# nvim config

Portable, readable, non-bloat Neovim configuration.
Less plugins, more config code.

## Structure

- `plugins/` – Custom plugins
- `lua/udv/`
    - `options/` – config
    - `remaps/` – remaps
    - `plugins.lua` – Plugin list
    - `plugins/` – Plugin configs
    - `snippets/` - LuaSnip snippets

## Portability

[`vimrc.vim`](./vimrc.vim) provides minimal setup for any environment.
Lua config builds on top - to be used on machines where plugins are allowed.

Install:
```bash
[ -f ~/.vimrc ] && mv ~/.vimrc ~/.vimrc.bk; curl -sL https://raw.githubusercontent.com/raydrivers/dotfiles/main/nvim/vimrc.vim -o ~/.vimrc
```

Revert:
```bash
[ -f ~/.vimrc.bk ] && mv ~/.vimrc.bk ~/.vimrc || [ -f ~/.vimrc ] && rm ~/.vimrc
```
