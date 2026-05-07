backup() {
    local target="$1"

    if [ ! -e "$target" ] && [ ! -L "$target" ]; then
        return
    fi

    mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
}

section() {
    local name="$1"

    if [ -n "$section_seen" ]; then
        echo
    fi

    echo "==> $name"
    section_seen=1
}

lnk() {
    local path="$1"
    local source="$DOTFILES_DIR/$path"
    local target="$2"
    local name="$(basename "$path")"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "@ $name"
        return
    fi

    mkdir -p "$(dirname "$target")"

    backup "$target"
    ln -sfn "$source" "$target"

    echo "+ $name"
}

git_config_add_once() {
    local file="$1"
    local key="$2"
    local value="$3"

    if git config --file "$file" --get-all "$key" | grep -qF "$value"; then
        return
    fi

    git config --file "$file" --add "$key" "$value"
}

cleanup_find() {
    find "${cleanup_dirs[@]}" -maxdepth 1 "$@" 2>/dev/null
}

cleanup_collect_backups() {
    local file

    while IFS= read -r file; do
        cleanup_files+=("$file")
    done < <(
        cleanup_find -name "*.backup.*"
    )
}

cleanup_collect_stale_links() {
    local link
    local target

    while IFS= read -r link; do
        target="$(readlink "$link")"

        from_dotfiles=
        stale=

        if [ "${target#"$DOTFILES_DIR"}" != "$target" ]; then
            from_dotfiles=1
        fi

        if [ ! -e "$link" ]; then
            stale=1
        fi

        # Only cleanup files created by this repo
        if [ -n "$from_dotfiles" ] && [ -n "$stale" ]; then
            cleanup_files+=("$link")
        fi
    done < <(
        cleanup_find -type l
    )
}

cleanup_confirm() {
    local confirm

    for file in "${cleanup_files[@]}"; do
        echo "$file"
    done

    echo

    read -rp "Delete ${#cleanup_files[@]} files? [y/N]: " confirm < /dev/tty

    if [[ "$confirm" != [yY] ]]; then
        echo "@ skipped"
        exit 0
    fi
}

cleanup_delete() {
    for file in "${cleanup_files[@]}"; do
        rm -r "$file"
        echo "- $file"
    done
}
