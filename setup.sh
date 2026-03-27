#!/bin/bash

_lib="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
_lib="$_lib/scripts/lib"
. "$_lib/log.sh"
. "$_lib/link.sh"

detect_environment() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -n "$WSL_DISTRO_NAME" ]] \
         || grep --quiet --ignore-case microsoft /proc/version 2>/dev/null
    then
        echo "wsl"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}


link_utility_scripts() {
    list_files "$DOTFILES_DIR/scripts"/* | link_to_bin

    local platform="$DOTFILES_DIR/scripts/$ENV_TYPE"
    if [[ -d "$platform" ]]; then
        list_files "$platform"/* | link_to_bin
    fi
}

setup_git() {
    bash "$DOTFILES_DIR/git/setup.sh"
}

setup_scripts() {
    log_section "Setting up utility scripts..."
    link_utility_scripts
}

setup_kitty() {
    log_section "Setting up Kitty..."
    link_config kitty
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
    link_config nvim

    log_info "Starship themes: $DOTFILES_DIR/starship/"
    log_warn "Use 'starship-change <theme>.toml' to switch"
    if [[ ! -f "$HOME/.config/starship.toml" \
       && ! -L "$HOME/.config/starship.toml" ]]
    then
        create_link \
            "$DOTFILES_DIR/starship/simple.toml" \
            "$HOME/.config/starship.toml"
    fi

    link_config tmux
}

setup_linux_desktop() {
    if [[ "$ENV_TYPE" != "linux" ]]; then
        return 0
    fi
    if [[ "$DESKTOP" != true ]]; then
        log_info "Desktop skipped. Rerun with --desktop to set up."
        return 0
    fi

    log_section "Linux Desktop"
    link_config hypr
    link_config waybar
    link_config rofi

    sudo cp -r \
        "$DOTFILES_DIR/sddm/monochrome" \
        "/usr/share/sddm/themes/"
    sudo cp \
        "$DOTFILES_DIR/sddm/sddm.conf" \
        "/etc/sddm.conf"
}

setup_shell_configs() {
    create_link \
        "$DOTFILES_DIR/zsh/.zshrc" \
        "$HOME/.zshrc"
}

setup_macos() {
    if [[ "$ENV_TYPE" != "macos" ]]; then
        return 0
    fi
    log_section "macOS-specific steps"

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

setup_ai() {
    local ai_setup="$DOTFILES_DIR/ai/setup.sh"
    if [[ ! -f "$ai_setup" ]]; then
        log_warn "AI submodule not initialized, skipping"
        return 0
    fi
    log_section "AI tools"
    bash "$ai_setup"
}

PACKAGES=(
    zsh tmux direnv starship neovim
    ripgrep fd node tree-sitter
)

setup_packages() {
    log_section "Installing packages..."
    "$DOTFILES_DIR/scripts/pkg-install" "${PACKAGES[@]}"
}

ALL_MODULES=(
    git
    scripts
    kitty
    wsl_fixes
    configs
    shell_configs
    linux_desktop
    macos
    ai
)

DESKTOP=false
DRY_RUN=false
INSTALL_PACKAGES=false
modules=()

for arg in "$@"; do
    case "$arg" in
        --desktop) DESKTOP=true ;;
        --dry-run|-n) DRY_RUN=true ;;
        --pkg) INSTALL_PACKAGES=true ;;
        *) modules+=("$arg") ;;
    esac
done

export DRY_RUN

ENV_TYPE=$(detect_environment)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "$ENV_TYPE" == "unknown" ]]; then
    die "Unsupported OS: OSTYPE=$OSTYPE"
fi

log_info "Environment: ${ENV_TYPE}"
log_info "dotfiles: ${DOTFILES_DIR}"
if [[ "$DRY_RUN" == true ]]; then
    log_warn "Dry-run mode — no changes will be made"
fi

if [[ ${#modules[@]} -eq 0 ]]; then
    modules=("${ALL_MODULES[@]}")
fi

failures=0
for mod in "${modules[@]}"; do
    if ! declare -f "setup_$mod" >/dev/null; then
        die "Unknown module: $mod"
    fi
    if ! (set -e; "setup_$mod"); then
        log_error "Module failed: $mod"
        failures=$((failures + 1))
    fi
done

if [[ "$INSTALL_PACKAGES" == true ]]; then
    if ! (set -e; setup_packages); then
        log_error "Package install failed"
        failures=$((failures + 1))
    fi
fi

if [[ $failures -gt 0 ]]; then
    log_error "$failures module(s) failed"
    exit 1
fi

log_section "Setup complete"
log_warn "Restart terminal for changes to take effect"
