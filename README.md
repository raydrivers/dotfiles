# dotfiles

Cross-platform dotfiles for macOS, Linux, WSL, and
Windows (Git Bash).

```bash
git clone --recursive https://github.com/raydrivers/dotfiles ~/dotfiles
cd ~/dotfiles && ./setup.sh
```

## Prerequisites

- bash
- git
- curl

Optional tools (setup skips what's missing):

- nvim
- starship
- direnv
- delta (auto-installed by setup)

## Platform support

| Feature              | macOS | Linux | WSL | Windows (Git Bash) |
|----------------------|-------|-------|-----|--------------------|
| git config           | yes   | yes   | yes | yes                |
| git scripts          | yes   | yes   | yes | yes                |
| delta install        | yes   | yes   | -   | yes                |
| utility scripts      | yes   | yes   | yes | -                  |
| nvim config          | yes   | yes   | yes | -                  |
| kitty config         | yes   | yes   | yes | -                  |
| tmux config          | yes   | yes   | yes | -                  |
| starship config      | yes   | yes   | yes | -                  |
| zsh config           | yes   | yes   | yes | -                  |
| Homebrew completions | yes   | -     | -   | -                  |
| Raycast config       | yes   | -     | -   | -                  |
| Hyprland / Waybar    | -     | yes   | -   | -                  |
| sddm theme          | -     | yes   | -   | -                  |

Linux desktop features require `./setup.sh --desktop`.

## Not yet handled

- Windows: no config linking (`~/.config` layout not
  used by most Windows tools)
- Windows: `setup.sh` detects "unknown" environment
  and runs nothing beyond git setup
- WSL: delta not auto-installed (runs Linux binaries
  but install path assumes native Linux)
- Symlinks on Windows Git Bash require admin or
  Developer Mode enabled
