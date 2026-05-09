native_path() {
    local path="$1"
    local native

    native="$(cygpath -m "$path" 2>/dev/null)" && path="$native"
    printf '%s\n' "$path"
}

windows_path() {
    local path="$1"
    local native

    native="$(cygpath -w "$path" 2>/dev/null)" && path="$native"
    printf '%s\n' "$path"
}

windows_shell() {
    case "$(uname -s 2>/dev/null)" in
        MINGW*|MSYS*|CYGWIN*) return 0 ;;
    esac

    return 1
}

native_link() {
    local source="$1"
    local target="$2"
    local source_path
    local target_path

    if ! windows_shell; then
        ln -sfn "$source" "$target"
        return
    fi

    source_path="$(windows_path "$source")"
    target_path="$(windows_path "$target")"

    if [ -d "$source" ]; then
        cmd //c mklink //J "$target_path" "$source_path" >/dev/null
        return
    fi

    cmd //c mklink //H "$target_path" "$source_path" >/dev/null
}

native_link_matches() {
    local source="$1"
    local target="$2"
    local actual

    if [ "$source" -ef "$target" ] 2>/dev/null; then
        return 0
    fi

    if [ ! -L "$target" ]; then
        return 1
    fi

    actual="$(readlink "$target")"

    [ "$(native_path "$actual")" = "$(native_path "$source")" ]
}
