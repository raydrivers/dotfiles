# `nvim` config
This is my own nvim configuration.
<!--Yeah, I use neovim btw-->

The goal is a **portable**, **readable** config that works across package managers with minimal changes.

### Structure

- [`./plugins`](./plugins) – Custom plugins  
- [`./themes`](./themes) – Custom color schemes (built with [`lush.nvim`](https://github.com/rktjmp/lush.nvim))  
- `lua/`
    - `options/` – Core configuration and remaps for plugins
    - `pkgs/` – Simple package manager abstraction
    - `plugins/`
        - Organized by **lifecycle step** (config, init, etc.)  
        - Separate directories for each package manager  
    - `prelude/` – Runs first, before all other configurations  
    - `utils/` – Global utility functions

### Portability
[`.vimrc`](./vimrc.vim) contains a minimal setup for any environment, enabling Vim/Neovim with essential hotkeys.
The goal is to override as little as possible, so I can still use plain vim on any machine.

The Lua config builds on top of this minimal setup, designed for personal machines where plugins are allowed.

Here's a quick command to get it on any machine:
```bash
[ -f ~/.vimrc ] && mv ~/.vimrc ~/.vimrc.bk; curl -sL https://raw.githubusercontent.com/udvsharp/dotfiles/main/nvim/vimrc.vim -o ~/.vimrc
```

...and to revert this change:
```bash
[ -f ~/.vimrc.bk ] && mv ~/.vimrc.bk ~/.vimrc || [ -f ~/.vimrc ] && rm ~/.vimrc
```
