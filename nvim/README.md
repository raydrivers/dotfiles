# nvim config

Portable, readable, non-bloat Neovim configuration.

## Structure

- `plugins/` – Custom plugins
- `themes/` – Color schemes (lush.nvim)
- `lua/`
  - `options/` – Core config and remaps
  - `pkgs/` – Package manager abstraction
  - `plugins/` – Plugin configs by lifecycle
  - `prelude/` – First-run configuration
  - `utils/` – Global utilities

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
