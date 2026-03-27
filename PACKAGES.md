# Packages

Manual install reference. Previously handled by setup.sh.

## Required

| Package      | Binary         | brew          | nix           | apt              | dnf            | pacman          |
|--------------|----------------|---------------|---------------|------------------|----------------|-----------------|
| zsh          | zsh            | zsh           | zsh           | zsh              | zsh            | zsh             |
| tmux         | tmux           | tmux          | tmux          | tmux             | tmux           | tmux            |
| direnv       | direnv         | direnv        | direnv        | direnv           | direnv         | direnv          |
| starship     | starship       | starship      | starship      | *(curl below)*   | *(curl below)* | starship        |
| neovim       | nvim           | neovim        | neovim        | neovim           | neovim         | neovim          |
| ripgrep      | rg             | ripgrep       | ripgrep       | ripgrep          | ripgrep        | ripgrep         |
| fd           | fd             | fd            | fd            | fd-find          | fd-find        | fd              |
| tree-sitter  | tree-sitter    | tree-sitter   | tree-sitter   | *(npm below)*    | *(npm below)*  | tree-sitter-cli |
| build-tools  | cc             | *(xcode-cli)* | —             | build-essential  | gcc make       | base-devel      |
| node         | node           | node          | nodejs        | nodejs npm       | nodejs npm     | nodejs npm      |

On apt/dnf, `fd-find` installs as `fdfind`. Symlink it:

    ln -sf "$(command -v fdfind)" ~/.local/bin/fd

## LSP servers (optional)

| Server                  | brew | nix  | pacman | apt/dnf |
|-------------------------|------|------|--------|---------|
| clangd                  | clangd | clangd | clang | clangd |
| lua-language-server     | yes  | yes  | yes    | —       |
| rust-analyzer           | yes  | yes  | yes    | yes     |
| cmake-language-server   | yes  | yes  | —      | —       |
| pyright                 | yes  | yes  | yes    | —       |
| elixir-ls               | yes  | yes  | —      | —       |
| jdtls                   | yes  | —    | —      | —       |
| zls                     | yes  | yes  | yes    | —       |

## Fallback installs

**starship** (apt/dnf):

    curl -sS https://starship.rs/install.sh | sh

**nvm + node** (Linux/WSL):

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    nvm install --lts
    nvm alias default 'lts/*'

**tree-sitter** (apt/dnf):

    npm i -g tree-sitter-cli

**kotlin-lsp**:

    # Download from https://download-cdn.jetbrains.com/kotlin-lsp/
    # Extract to ~/.local/share/kotlin-lsp
    # Symlink kotlin-lsp.sh to ~/.local/bin/kotlin-lsp
