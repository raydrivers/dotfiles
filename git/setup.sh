#!/bin/bash
set -o errexit

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "$DOTFILES_DIR/scripts/lib/log.sh"
. "$DOTFILES_DIR/scripts/lib/link.sh"

git_config_add_once() {
    local key="$1" value="$2"
    if ! git config --global --get-all "$key" \
        | grep --quiet --fixed-strings "$value"
    then
        git config --global --add "$key" "$value"
    fi
}

log_section "Setting up Git..."

mkdir -p "$HOME/.config/git" "$HOME/.local/bin"
rm -f "$HOME/.config/git/custom"
ln -sf "$DOTFILES_DIR/git/config" "$HOME/.config/git/custom"
log_ok "$HOME/.config/git/custom"

git_config_add_once include.path "~/.config/git/custom/common.gitconfig"

if ! command -v delta &>/dev/null; then
    "$DOTFILES_DIR/git/install-delta.sh"
fi

list_files "$DOTFILES_DIR/git/scripts"/git-* | link_to_bin
