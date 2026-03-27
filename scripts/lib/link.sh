backup() {
    local target="$1"
    if [[ ! -e "$target" && ! -L "$target" ]]; then
        return 0
    fi

    if [[ "${DRY_RUN:-}" == true ]]; then
        log_warn "[dry-run] Would back up $target"
        return 0
    fi

    local backup_path
    backup_path="${target}.backup.$(date +%Y%m%d_%H%M%S)"

    log_warn "Backing up $target"
    mv "$target" "$backup_path"
    if [[ ! -e "$backup_path" && ! -L "$backup_path" ]]; then
        log_error "Failed to create backup of $target"
        return 1
    fi
}

create_link() {
    local source="$1" target="$2"

    if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
        log_ok "$target (ok)"
        return 0
    fi

    if [[ "${DRY_RUN:-}" == true ]]; then
        log_info "[dry-run] $source -> $target"
        return 0
    fi

    mkdir -p "$(dirname "$target")"
    backup "$target"
    ln -sf "$source" "$target"

    if [[ ! -e "$target" ]]; then
        log_error "Failed to link $source -> $target"
        return 1
    fi

    log_ok "$target"
}

link_config() {
    create_link "$DOTFILES_DIR/$1" "$HOME/.config/$1"
}

list_files() {
    printf '%s\n' "$@"
}

link_to_bin() {
    while IFS= read -r script; do
        [[ -f "$script" ]] || continue
        create_link \
            "$script" \
            "$HOME/.local/bin/$(basename "$script")"
    done
}
