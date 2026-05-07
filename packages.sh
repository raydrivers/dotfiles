#!/bin/bash

tools=(
    # setup.sh requirements
    bash
    git
    curl
    jq

    # Shell
    zsh
    tmux
    direnv
    starship

    # Utilities
    htop
    wget
    tree
    tokei
    ripgrep
    fd
    sd

    # Lang
    python
    go
    node
    zig

    # Dev tools
    build-tools
    gdb
    cmake
    gradle

    # Neovim core
    neovim
    tree-sitter-cli

    # Neovim language tools
    clang-tools
    lua-language-server
    pyright
    ruff
    rust-analyzer
    typescript-language-server
)

package_name() {
    local tool="$1"

    case "$manager:$tool" in
        brew:python) echo "python" ;;
        brew:tree-sitter-cli) echo "tree-sitter" ;;
        brew:build-tools) ;;
        brew:clang-tools) echo "llvm" ;;

        pacman:python) echo "python" ;;
        pacman:node) echo "nodejs" ;;
        pacman:build-tools) echo "base-devel" ;;
        pacman:clang-tools) echo "clang" ;;

        apt:python) echo "python3" ;;
        apt:go) echo "golang-go" ;;
        apt:fd) echo "fd-find" ;;
        apt:node) echo "nodejs" ;;
        apt:tree-sitter-cli) ;;
        apt:build-tools) echo "build-essential" ;;
        apt:clang-tools) echo "clangd clang-format" ;;
        apt:lua-language-server) ;;
        apt:pyright) ;;
        apt:ruff) ;;
        apt:rust-analyzer) ;;
        apt:typescript-language-server) ;;

        winget:bash) ;;
        winget:curl) ;;
        winget:zsh) ;;
        winget:tmux) ;;
        winget:direnv) ;;
        winget:git) echo "Git.Git" ;;
        winget:jq) echo "jqlang.jq" ;;
        winget:python) echo "Python.Python.3.13" ;;
        winget:go) echo "GoLang.Go" ;;
        winget:zig) echo "zig.zig" ;;
        winget:starship) echo "Starship.Starship" ;;
        winget:neovim) echo "Neovim.Neovim" ;;
        winget:ripgrep) echo "BurntSushi.ripgrep.MSVC" ;;
        winget:fd) echo "sharkdp.fd" ;;
        winget:sd) echo "chmln.sd" ;;
        winget:node) echo "OpenJS.NodeJS.LTS" ;;
        winget:tree-sitter-cli) ;;
        winget:build-tools) ;;
        winget:gdb) ;;
        winget:cmake) echo "Kitware.CMake" ;;
        winget:gradle) echo "Gradle.Gradle" ;;
        winget:clang-tools) echo "LLVM.LLVM" ;;
        winget:lua-language-server) echo "LuaLS.lua-language-server" ;;
        winget:pyright) ;;
        winget:ruff) echo "astral-sh.ruff" ;;
        winget:rust-analyzer) ;;
        winget:typescript-language-server) ;;
        winget:htop) ;;
        winget:wget) ;;
        winget:tree) ;;
        winget:tokei) echo "XAMPPRocky.Tokei" ;;

        *) echo "$tool" ;;
    esac
}

packages=()
dry_run=

if [ "$1" = "--dry" ]; then
    dry_run=1
    manager="$2"
elif command -v brew >/dev/null; then
    manager="brew"
elif command -v pacman >/dev/null; then
    manager="pacman"
elif command -v apt >/dev/null; then
    manager="apt"
elif command -v winget >/dev/null; then
    manager="winget"
else
    echo "No supported package manager found" >&2
    exit 1
fi

case "$manager" in
    brew|pacman|apt|winget) ;;
    *) echo "Unsupported package manager: $manager" >&2; exit 1 ;;
esac

for tool in "${tools[@]}"; do
    for package in $(package_name "$tool"); do
        packages+=("$package")
    done
done

if [ -n "$dry_run" ]; then
    printf '%s\n' "${packages[@]}"
elif [ "$manager" = "brew" ]; then
    brew install "${packages[@]}"
elif [ "$manager" = "pacman" ]; then
    sudo pacman -S --needed --noconfirm "${packages[@]}"
elif [ "$manager" = "apt" ]; then
    sudo apt install -y "${packages[@]}"
elif [ "$manager" = "winget" ]; then
    for package in "${packages[@]}"; do
        winget install --id "$package" \
            --accept-package-agreements \
            --accept-source-agreements \
            --disable-interactivity
    done
fi
