#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

section_seen=
. "$DOTFILES_DIR/scripts/setup-lib.sh"

cleanup_files=()
cleanup_dirs=(
    "$HOME"
    "$HOME/.config"
    "$HOME/.local/bin"
    "$HOME/.claude"
    "$HOME/.codex"
)

section "cleanup"

cleanup_collect_backups
cleanup_collect_stale_links

if [ ${#cleanup_files[@]} -eq 0 ]; then
    echo "@ nothing"
    exit 0
fi

cleanup_confirm
cleanup_delete
