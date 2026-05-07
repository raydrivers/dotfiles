#!/bin/bash

# Not set until this setup
# Other scripts can rely on the env var
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detect only systems with specific configuration
macos=
linux=
windows=

section_seen=
. "$DOTFILES_DIR/scripts/setup-lib.sh"

case "$OSTYPE" in
    darwin*) macos=1 ;;
    linux*) linux=1 ;;
    msys*|mingw*) windows=1 ;;
esac

section "configs"

if [ ! -f "$HOME/.posix-profile" ]; then
    touch "$HOME/.posix-profile"
    echo "+ .posix-profile"
else
    echo "@ .posix-profile"
fi

lnk "bash/.bashrc" "$HOME/.bashrc"
lnk "nvim" "$HOME/.config/nvim"

# tmux, kitty and zsh are not available on windows (sadly)
if [ -z "$windows" ]; then
    lnk "kitty" "$HOME/.config/kitty"
    lnk "tmux" "$HOME/.config/tmux"
    # TODO: keep zshrc and bashrc thin wrappers around .posix-profile?
    lnk "zsh/.zshrc" "$HOME/.zshrc"
fi

lnk "starship/simple.toml" "$HOME/.config/starship.toml"

section "scripts"

scripts=(
    "$DOTFILES_DIR/scripts"/*
    "$DOTFILES_DIR/git/scripts"/git-*
)
if [ -n "$macos" ]; then
    scripts+=("$DOTFILES_DIR/scripts/macos"/*)
fi
for script in "${scripts[@]}"; do
    if [ ! -f "$script" ]; then
        continue
    fi

    if [ ! -x "$script" ]; then
        continue
    fi

    script_name="$(basename "$script")"
    lnk "${script#"$DOTFILES_DIR/"}" "$HOME/.local/bin/$script_name"
done

section "git"

lnk "git/config" "$HOME/.config/git/custom"

git_config_add_once "$HOME/.gitconfig" \
    "include.path" "$HOME/.config/git/custom/common.gitconfig"

"$DOTFILES_DIR/git/install-delta.sh"

if [ -n "$linux" ]; then
    if [ "$1" = "--desktop" ]; then
        section "linux"

        bash "$DOTFILES_DIR/linux/desktop.sh"
    fi
fi

if [ -n "$windows" ]; then
    section "windows"

    bash "$DOTFILES_DIR/windows/fix-windows-terminal.sh"
fi

section "ai"

bash "$DOTFILES_DIR/ai/setup.sh"
