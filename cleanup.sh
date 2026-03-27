#!/bin/bash
set -e

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
. "$DOTFILES_DIR/scripts/lib/log.sh"

search_dirs=(
    "$HOME/.config"
    "$HOME/.local/bin"
)

find_backups() {
    backups=()
    while IFS= read -r line; do
        backups+=("$line")
    done < <(
        find "$HOME" -maxdepth 1 \
            -name "*.backup.*" \
            \( -type f -o -type l \) \
            2>/dev/null
        find "${search_dirs[@]}" \
            -name "*.backup.*" \
            \( -type f -o -type l -o -type d \) \
            2>/dev/null
    )
}

find_stale_symlinks() {
    stale=()
    local link target
    while IFS= read -r link; do
        target="$(readlink "$link")"
        case "$target" in
            "$DOTFILES_DIR"*) ;;
            *) continue ;;
        esac
        if [[ ! -e "$link" ]]; then
            stale+=("$link")
        fi
    done < <(
        find "$HOME" -maxdepth 1 -type l 2>/dev/null
        find "${search_dirs[@]}" -type l 2>/dev/null
    )
}

delete_listed() {
    local label="$1"
    shift
    local files=("$@")

    if [[ ${#files[@]} -eq 0 ]]; then
        return 0
    fi

    log_warn "Found $label:"
    for f in "${files[@]}"; do
        echo "  $f"
    done
    echo
    echo "Total: ${#files[@]}"
    echo

    read -rp "Delete? [y/N]: " confirm
    if [[ "$confirm" != [yY] ]]; then
        log_warn "Skipped"
        return 0
    fi

    local count=0
    for f in "${files[@]}"; do
        if rm -rf "$f"; then
            log_ok "$f"
            ((count++)) || true
        else
            log_error "  $f"
        fi
    done
    log_section "Deleted $count $label"
}

find_backups
find_stale_symlinks

if [[ ${#backups[@]} -eq 0 && ${#stale[@]} -eq 0 ]]; then
    log_info "Nothing to clean up"
    exit 0
fi

delete_listed "backup files" "${backups[@]}"
delete_listed "stale symlinks" "${stale[@]}"
