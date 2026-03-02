# dotfiles by ray

My dotfiles for macOS, Linux, WSL, and Windows (MSYS/MinGW).

## Quick Start

```bash
git clone https://github.com/raydrivers/dotfiles ~/dotfiles && cd ~/dotfiles && ./setup.sh
```

After setup, clean up any backup files created during installation:

```bash
./cleanup.sh
```

## What's Included

| Component | Platforms |
|-----------|-----------|
| Zsh | macOS, Linux, WSL |
| Bash + PowerShell | Windows |
| Git (config, aliases, custom commands) | All |
| Neovim | All |
| Starship prompt | All |
| Tmux | macOS, Linux, WSL |
| Kitty | macOS, Linux, WSL |
| Hyprland, Waybar, Rofi, SDDM | Linux (optional) |

### Git Custom Commands

| Command | Description |
|---------|-------------|
| `git last [n]` | Show last commit(s) |
| `git unpushed` | List commits not yet pushed |
| `git rebase-unpushed` | Rebase unpushed commits |
| `git wt-add <branch>` | Add a worktree |
| `git wt-peek` | Inspect worktree metadata |

New `git-*` scripts added to `git/` are symlinked automatically.

### Starship Themes

Switch themes with:

```bash
starship-change <theme>.toml
```

Available themes are in `starship/`.

### Dev Scripts

Development iteration runner that integrates with Neovim's quickfix lists.

**Initialize a project:**

```bash
dev-init          # creates ./dev from default(cmake now) template
dev-init python   # creates ./dev from python template
```

This creates a `./dev` script and adds dev files to `.gitignore`.

**Run:**

```bash
dev       # runs ./dev, on failure opens nvim at first error
dev -w    # include warnings in quickfix list
```

The `dev` command runs your project's local `./dev` script.
Output is saved to `.dev.log`.
Parses errors are parsed with `dev-parse` and saved to `.dev.log.qf`.

Neovim is opened with the quickfix list on failure.

#### Adding a Parser

Parsers live in `scripts/dev-parsers/` and are AWK scripts.
Each parser extracts `file:line:col:message` from build output.

To add one:
1. Create `scripts/dev-parsers/<name>` as an AWK script
2. Source `common` for helpers: `emit(file, line, col, message)`

The parser will automatically be called to parse `.dev.log`.

#### Adding a Template

Templates live in `scripts/dev-templates/`.
Add a new file named after the toolchain - it will be available as `dev-init <name>`.

## Structure

```
git/          Git config and custom commands
nvim/         Neovim configuration
kitty/        Kitty terminal config
tmux/         Tmux config (modular)
zsh/          Zsh config
bash/         Bash config
powershell/   PowerShell profile
starship/     Starship prompt themes
hypr/         Hyprland config (Linux)
waybar/       Waybar config (Linux)
rofi/         Rofi config (Linux)
sddm/         SDDM login theme (Linux)
macos/        macOS-specific (Raycast)
scripts/      Utility and dev scripts
setup.sh      Install everything
cleanup.sh    Remove backup files
```
