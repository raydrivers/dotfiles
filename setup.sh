#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}$1${NC}" >&2; }
log_ok() { echo -e "${GREEN}✓${NC} $1" >&2; }
log_warn() { echo -e "${YELLOW}$1${NC}" >&2; }
log_error() { echo -e "${RED}$1${NC}" >&2; }
log_section() { echo -e "\n${GREEN}$1${NC}" >&2; }

detect_environment() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -n "$WSL_DISTRO_NAME" ]] \
        || grep -qi microsoft /proc/version 2>/dev/null
    then
        echo "wsl"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" ]] \
      || [[ "$OSTYPE" == "mingw"* ]] \
      || [[ "$OSTYPE" == "cygwin" ]]
    then
        echo "windows"
    else
        echo "unknown"
    fi
}

confirm() {
    local response
    read -rp "$1 [y/N]: " response
    [[ "$response" == [yY] ]]
}

backup() {
    local target="$1"
    if [[ ! -e "$target" && ! -L "$target" ]]; then
        return 0
    fi

    local backup_path
    backup_path="${target}.backup.$(date +%Y%m%d_%H%M%S)"
    log_warn "Backing up $target"
    mv "$target" "$backup_path"

    if [[ ! -e "$backup_path" ]]; then
        log_error "Failed to create backup of $target"
        return 1
    fi
}

create_link() {
    local source="$1" target="$2"

    mkdir -p "$(dirname "$target")"
    backup "$target"
    ln -sf "$source" "$target"

    if [[ ! -e "$target" ]]; then
        log_error "Failed to link $source -> $target"
        return 1
    fi

    log_ok "$target"
}

detect_package_managers() {
    local managers=()
    if command -v brew &>/dev/null; then
        managers+=("brew")
    fi
    if command -v nix &>/dev/null; then
        managers+=("nix")
    fi
    if command -v apt-get &>/dev/null; then
        managers+=("apt")
    fi
    if command -v dnf &>/dev/null; then
        managers+=("dnf")
    fi
    if command -v pacman &>/dev/null; then
        managers+=("pacman")
    fi
    if command -v winget.exe &>/dev/null; then
        managers+=("winget")
    fi
    echo "${managers[@]}"
}

prompt_package_manager() {
    local managers=("$@")

    if [[ ${#managers[@]} -eq 0 ]]; then
        log_error "No supported package manager found"
        return 1
    fi

    if [[ ${#managers[@]} -eq 1 ]]; then
        echo "${managers[0]}"
        return
    fi

    log_warn "Available package managers:"
    for i in "${!managers[@]}"; do
        echo "  $((i+1))) ${managers[$i]}" >&2
    done

    local choice
    read -rp "Select [1-${#managers[@]}]: " choice
    if [[ "$choice" -ge 1 \
       && "$choice" -le ${#managers[@]} ]] 2>/dev/null
    then
        echo "${managers[$((choice-1))]}"
    else
        log_error "Invalid selection"
        return 1
    fi
}

install_packages() {
    local pm="$1"; shift
    case "$pm" in
        brew) brew-install "$@" ;;
        nix)
            local pkgs=()
            for p in "$@"; do
                pkgs+=("nixpkgs#$p")
            done
            nix profile install "${pkgs[@]}"
            ;;
        apt)
            sudo apt-get update -qq \
                && sudo apt-get install -y "$@"
            ;;
        dnf)    sudo dnf install -y "$@" ;;
        pacman) sudo pacman -S --needed "$@" ;;
        winget)
            for p in "$@"; do
                winget.exe install --id "$p" -e \
                    --accept-source-agreements \
                    --accept-package-agreements
            done
            ;;
    esac
}

uninstall_packages() {
    local pm="$1"; shift
    case "$pm" in
        brew)   brew uninstall "$@" ;;
        nix)
            local pkgs=()
            for p in "$@"; do
                pkgs+=("nixpkgs#$p")
            done
            nix profile remove "${pkgs[@]}"
            ;;
        apt)    sudo apt-get remove -y "$@" ;;
        dnf)    sudo dnf remove -y "$@" ;;
        pacman) sudo pacman -Rs --noconfirm "$@" ;;
        winget)
            for p in "$@"; do
                winget.exe uninstall --id "$p" -e
            done
            ;;
    esac
}

resolve_pkg() {
    local pm="$1" pkg="$2"
    if [[ "$pm" == "winget" ]]; then
        case "$pkg" in
            neovim)      echo "Neovim.Neovim" ;;
            ripgrep)     echo "BurntSushi.ripgrep.MSVC" ;;
            fd)          echo "sharkdp.fd" ;;
            direnv)      echo "direnv.direnv" ;;
            starship)    echo "Starship.Starship" ;;
            zsh)         return ;;
            tmux)        return ;;
            tree-sitter) return ;;
            build-tools) return ;;
            node)        return ;;
            *)           echo "$pkg" ;;
        esac
        return
    fi
    case "$pkg" in
        fd)
            if [[ "$pm" == apt || "$pm" == dnf ]]; then
                echo "fd-find"
            else
                echo "fd"
            fi
            ;;
        node)
            case "$pm" in
                brew) echo "node" ;;
                nix)  echo "nodejs" ;;
                *)    echo "nodejs npm" ;;
            esac ;;
        tree-sitter)
            case "$pm" in
                apt|dnf) return ;;
                pacman)  echo "tree-sitter-cli" ;;
                *)       echo "tree-sitter" ;;
            esac ;;
        build-tools)
            case "$pm" in
                apt)    echo "build-essential" ;;
                dnf)    echo "gcc make" ;;
                pacman) echo "base-devel" ;;
            esac ;;
        starship)
            case "$pm" in
                apt|dnf) return ;;
                *)       echo "starship" ;;
            esac ;;
        clangd)
            case "$pm" in
                pacman) echo "clang" ;;
                winget) return ;;
                *)      echo "clangd" ;;
            esac ;;
        rust-analyzer)
            case "$pm" in
                winget) return ;;
                *)      echo "rust-analyzer" ;;
            esac ;;
        lua-language-server|pyright)
            case "$pm" in
                brew|nix|pacman) echo "$pkg" ;;
                *)               return ;;
            esac ;;
        cmake-language-server|elixir-ls)
            case "$pm" in
                brew|nix) echo "$pkg" ;;
                *)        return ;;
            esac ;;
        jdtls)
            case "$pm" in
                brew) echo "$pkg" ;;
                *)    return ;;
            esac ;;
        *) echo "$pkg" ;;
    esac
}

pkg_to_bin() {
    case "$1" in
        neovim)      echo "nvim" ;;
        ripgrep)     echo "rg" ;;
        tree-sitter) echo "tree-sitter" ;;
        node)        echo "node" ;;
        build-tools) echo "cc" ;;
        *)           echo "$1" ;;
    esac
}

detect_source() {
    local bin_path
    if ! bin_path="$(command -v "$1" 2>/dev/null)"; then
        return 1
    fi

    case "$bin_path" in
        /nix/*|*/.nix-profile/*)    echo "nix" ;;
        /opt/homebrew/*|/usr/local/Cellar/*) \
                                    echo "brew" ;;
        "$HOME/.nvm/"*)             echo "nvm" ;;
        /usr/bin/*|/bin/*)          echo "system" ;;
        *)                          echo "PATH" ;;
    esac
}

set_default_zsh() {
    if [[ "$ENV_TYPE" == "windows" ]]; then
        return 0
    fi

    if ! command -v zsh &>/dev/null; then
        log_error \
            "zsh not found - can't set as default"
        return 1
    fi

    local current_shell
    if [[ "$ENV_TYPE" == "macos" ]]; then
        current_shell="$(dscl . -read \
            "$HOME" UserShell 2>/dev/null \
            | awk '{print $2}')"
    else
        current_shell="$(getent passwd "$USER" \
            2>/dev/null | cut -d: -f7)"
    fi
    if [[ "$current_shell" == *"/zsh" ]]; then
        log_ok "zsh is already the default shell"
        return 0
    fi

    if ! confirm "Set zsh as default shell?"; then
        return 0
    fi

    if ! chsh -s "$(command -v zsh)"; then
        log_error \
            "Failed to set zsh as default shell"
        return 1
    fi

    log_ok "Default shell set to zsh"
}

load_nvm() {
    export NVM_DIR="$HOME/.nvm"
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        \. "$NVM_DIR/nvm.sh"
    fi
}

install_nvm() {
    if [[ -d "$HOME/.nvm" ]]; then
        log_ok "nvm"
        return 0
    fi

    log_warn "Installing nvm..."
    local nvm_url="https://raw.githubusercontent.com"
    nvm_url+="/nvm-sh/nvm/v0.40.1/install.sh"
    curl -o- "$nvm_url" | bash

    load_nvm
}

remove_system_node() {
    local sys_node
    sys_node="$(command -v node 2>/dev/null)" || true
    if [[ -z "$sys_node" \
        || "$sys_node" == "$HOME/.nvm/"* ]]
    then
        return 0
    fi

    local source
    source=$(detect_source node) || true
    log_warn "System node found (${source}):"
    echo "  - node $(node --version 2>/dev/null \
        || echo '(unknown version)')" >&2
    if command -v npm &>/dev/null; then
        echo "  - npm $(npm --version 2>/dev/null \
            || echo '(unknown version)')" >&2
    fi

    if ! confirm \
        "Uninstall system node so nvm manages it?"
    then
        return 0
    fi

    local node_pm
    read -ra managers <<< "$(detect_package_managers)"
    node_pm=$(prompt_package_manager "${managers[@]}") \
        || true
    if [[ -n "$node_pm" ]]; then
        local node_pkgs
        read -ra node_pkgs \
            <<< "$(resolve_pkg "$node_pm" node)"
        uninstall_packages "$node_pm" \
            "${node_pkgs[@]}" 2>/dev/null || true
    fi
    hash -r
}

install_node_nvm() {
    load_nvm

    remove_system_node

    nvm install --lts
    nvm alias default 'lts/*'
    log_ok "Node $(node --version) (nvm)"
}

setup_required_packages() {
    local pm="$1"

    local installed=()
    local missing=()
    for pkg in "${REQUIRED_PACKAGES[@]}"; do
        local bin
        bin=$(pkg_to_bin "$pkg")
        if source=$(detect_source "$bin"); then
            installed+=("$pkg ($source)")
        else
            local resolved
            resolved=$(resolve_pkg "$pm" "$pkg")
            if [[ -n "$resolved" ]]; then
                missing+=($resolved)
            fi
        fi
    done

    if [[ ${#installed[@]} -gt 0 ]]; then
        log_info "Already installed:"
        for pkg in "${installed[@]}"; do
            echo -e \
                "  ${GREEN}✓${NC} $pkg" >&2
        done
    fi

    if [[ ${#missing[@]} -eq 0 ]]; then
        log_info "All packages already installed"
        return 0
    fi

    log_warn "To install (${pm}):"
    for pkg in "${missing[@]}"; do
        echo "  - $pkg" >&2
    done
    echo "" >&2

    if ! confirm "Install these packages?"; then
        return 0
    fi

    install_packages "$pm" "${missing[@]}"
    post_install_fixups
}

link_git_scripts() {
    for script in "$DOTFILES_DIR"/git/git-*; do
        if [[ -f "$script" ]]; then
            create_link \
                "$script" \
                "$HOME/.local/bin/$(basename "$script")"
        fi
    done
}

link_utility_scripts() {
    local macos_only="screw brew-install"
    for script in "$DOTFILES_DIR"/scripts/*; do
        if [[ ! -f "$script" ]]; then
            continue
        fi
        local name
        name="$(basename "$script")"
        if [[ "$ENV_TYPE" != "macos" ]] \
            && [[ " $macos_only " == *" $name "* ]]
        then
            continue
        fi
        create_link \
            "$script" "$HOME/.local/bin/$name"
    done
}

symlink_fdfind() {
    # Some linux distributions install fd as fdfind
    if command -v fdfind &>/dev/null \
        && ! command -v fd &>/dev/null
    then
        ln -sf "$(command -v fdfind)" \
            "$HOME/.local/bin/fd"
    fi
}

install_tree_sitter_cli() {
    if ! command -v tree-sitter &>/dev/null; then
        load_nvm
        npm i -g tree-sitter-cli
    fi
}

install_starship_fallback() {
    if ! command -v starship &>/dev/null; then
        log_warn "Installing starship via curl..."
        curl -sS https://starship.rs/install.sh | sh
    fi
}

install_kotlin_lsp() {
    if command -v kotlin-lsp &>/dev/null; then
        log_ok "kotlin-lsp"
        return 0
    fi

    local version="261.13587.0"
    local platform
    case "$(uname -s)-$(uname -m)" in
        Darwin-arm64)  platform="mac-aarch64" ;;
        Darwin-x86_64) platform="mac-x64" ;;
        Linux-aarch64) platform="linux-aarch64" ;;
        Linux-x86_64)  platform="linux-x64" ;;
        *)
            log_warn "kotlin-lsp: unsupported platform"
            return 0 ;;
    esac

    local base_url="https://download-cdn.jetbrains.com"
    base_url+="/kotlin-lsp/${version}"
    local zip="kotlin-lsp-${version}-${platform}.zip"

    local dest="$HOME/.local/share/kotlin-lsp"
    local tmp
    tmp=$(mktemp -d)

    log_warn "Downloading kotlin-lsp ${version}..."
    curl -sLo "$tmp/$zip" "$base_url/$zip" || {
        log_error "Download failed"
        rm -rf "$tmp"
        return 1
    }

    rm -rf "$dest"
    mkdir -p "$dest"
    unzip -qo "$tmp/$zip" -d "$dest"
    rm -rf "$tmp"

    local launcher
    launcher=$(find "$dest" -name "kotlin-lsp.sh" \
        -type f | head -1)
    if [[ -z "$launcher" ]]; then
        log_error "kotlin-lsp launcher not found"
        return 1
    fi

    chmod +x "$launcher"
    ln -sf "$launcher" \
        "$HOME/.local/bin/kotlin-lsp"
    log_ok "kotlin-lsp ${version}"
}

post_install_fixups() {
    symlink_fdfind
    install_tree_sitter_cli
    install_starship_fallback
}

setup_git() {
    log_section "Setting up Git..."
    mkdir -p "$HOME/.config/git" "$HOME/.local/bin"
    create_link \
        "$DOTFILES_DIR/git" \
        "$HOME/.config/git/custom"
    if ! git config --global \
        --get-all include.path \
        | grep -q "custom/common"
    then
        git config --global --add include.path \
            "~/.config/git/custom/common.gitconfig"
    fi

    if [[ ! -f "$HOME/.config/git/themes.gitconfig" ]]
    then
        local delta_themes
        delta_themes="https://raw.githubusercontent.com"
        delta_themes+="/dandavison/delta/main"
        delta_themes+="/themes.gitconfig"
        curl -sLo \
            "$HOME/.config/git/themes.gitconfig" \
            "$delta_themes"
    fi

    if ! command -v delta &>/dev/null; then
        "$DOTFILES_DIR/git/install-delta.sh"
    fi

    link_git_scripts
}

setup_scripts() {
    log_section "Setting up utility scripts..."
    link_utility_scripts
}

setup_kitty() {
    if [[ "$ENV_TYPE" == "windows" ]]; then
        return 0
    fi
    log_section "Setting up Kitty..."
    create_link \
        "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
}

setup_packages() {
    log_section "Packages"

    if [[ "$ENV_TYPE" == "wsl" \
       || "$ENV_TYPE" == "linux" \
       || "$ENV_TYPE" == "windows" ]]
    then
        install_nvm
        install_node_nvm
    fi

    REQUIRED_PACKAGES=(
        zsh tmux direnv starship
        neovim
        ripgrep fd
        tree-sitter build-tools
    )
    if [[ "$ENV_TYPE" == "macos" ]]; then
        REQUIRED_PACKAGES+=(node)
    fi
    read -ra managers \
        <<< "$(detect_package_managers)"
    pm=$(prompt_package_manager \
        "${managers[@]}") && {
        setup_required_packages "$pm"
    }

    if [[ -n "${pm:-}" ]] \
        && confirm "Install LSP servers for Neovim?"
    then
        REQUIRED_PACKAGES=(
            clangd lua-language-server
            rust-analyzer cmake-language-server
            pyright elixir-ls
            jdtls
        )
        setup_required_packages "$pm"
        install_kotlin_lsp
    fi

    set_default_zsh
}

setup_wsl_fixes() {
    if [[ "$ENV_TYPE" != "wsl" ]]; then
        return 0
    fi
    log_section "WSL fixes"
    sudo mkdir -p /usr/share/zsh/vendor-completions
    log_ok "zsh vendor-completions dir"
}

setup_configs() {
    log_section "Configs"
    if [[ "$ENV_TYPE" == "windows" ]]; then
        create_link \
            "$DOTFILES_DIR/nvim" \
            "$HOME/AppData/Local/nvim"
    else
        create_link \
            "$DOTFILES_DIR/nvim" \
            "$HOME/.config/nvim"
    fi

    log_info \
        "Starship themes: $DOTFILES_DIR/starship/"
    log_warn \
        "Use 'starship-change <theme>.toml' to switch"
    if [[ ! -f "$HOME/.config/starship.toml" \
       && ! -L "$HOME/.config/starship.toml" ]]
    then
        create_link \
            "$DOTFILES_DIR/starship/simple.toml" \
            "$HOME/.config/starship.toml"
    fi

    if [[ "$ENV_TYPE" != "windows" ]]; then
        create_link \
            "$DOTFILES_DIR/tmux/tmux.conf" \
            "$HOME/.tmux.conf"
        create_link \
            "$DOTFILES_DIR/tmux" \
            "$HOME/.config/tmux"
    fi
}

setup_linux_desktop() {
    if [[ "$ENV_TYPE" != "linux" ]]; then
        return 0
    fi
    if ! confirm \
        "Set up Linux desktop (Hyprland, Waybar, Rofi, SDDM)?"
    then
        return 0
    fi
    log_section "Linux Desktop"
    create_link \
        "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"
    create_link \
        "$DOTFILES_DIR/waybar" \
        "$HOME/.config/waybar"
    create_link \
        "$DOTFILES_DIR/rofi" "$HOME/.config/rofi"
    sudo cp -r \
        "$DOTFILES_DIR/sddm/monochrome" \
        "/usr/share/sddm/themes/"
    sudo cp \
        "$DOTFILES_DIR/sddm/sddm.conf" \
        "/etc/sddm.conf"
}

setup_shell_configs() {
    if [[ "$ENV_TYPE" == "windows" ]]; then
        log_section "Shell configs (Windows)"
        create_link \
            "$DOTFILES_DIR/bash/.bashrc" \
            "$HOME/.bashrc"
        local ps_dir="$HOME/Documents/PowerShell"
        mkdir -p "$ps_dir"
        create_link \
            "$DOTFILES_DIR/powershell/profile.ps1" \
            "$ps_dir/Microsoft.PowerShell_profile.ps1"
    else
        create_link \
            "$DOTFILES_DIR/zsh/.zshrc" \
            "$HOME/.zshrc"
    fi
}

setup_macos() {
    if [[ "$ENV_TYPE" != "macos" ]]; then
        return 0
    fi
    log_section "macOS-specific steps"

    # Ensure /usr/local directories exist for
    # manually installed tools and libraries
    local dirs=(bin lib share include etc)
    for d in "${dirs[@]}"; do
        if [[ ! -d "/usr/local/$d" ]]; then
            sudo mkdir -p "/usr/local/$d"
            log_ok "Created /usr/local/$d"
        fi
    done

    if command -v brew &>/dev/null; then
        local brew_prefix
        brew_prefix="$(brew --prefix)"
        local comp="$brew_prefix/share/zsh/site-functions"
        if [[ -d "$comp" ]]; then
            log_ok "Homebrew completions: $comp"
        fi
    fi

    local raycast_dir
    raycast_dir="$HOME/Library/Application Support"
    raycast_dir+="/com.raycast.macos"
    if [[ -d "$raycast_dir" ]]; then
        create_link \
            "$DOTFILES_DIR/macos/raycast.rayconfig" \
            "$raycast_dir/raycast.rayconfig"
    else
        log_warn "Raycast not found, skipping"
    fi
}


ENV_TYPE=$(detect_environment)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" \
    && pwd)"

if [[ "$ENV_TYPE" == "windows" ]]; then
    export MSYS=winsymlinks:nativestrict
fi

log_info "Environment: ${ENV_TYPE}"
log_info "dotfiles: ${DOTFILES_DIR}"

setup_git
setup_scripts
setup_kitty
setup_packages
setup_wsl_fixes
setup_configs
setup_shell_configs
setup_linux_desktop
setup_macos

log_section "Setup complete"
log_warn "Restart terminal for changes to take effect"
