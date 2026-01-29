#!/bin/bash

# Dotfiles setup script
# Links configuration files to their proper locations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${GREEN}Setting up dotfiles from ${DOTFILES_DIR}${NC}"

# Function to create symlink with backup
create_link() {
    local source="$1"
    local target="$2"
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Backup existing file/symlink if it exists
    if [[ -e "$target" || -L "$target" ]]; then
        echo -e "${YELLOW}Backing up existing $target${NC}"
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Create symlink
    ln -sf "$source" "$target"
    echo -e "${GREEN}${NC} Linked $source -> $target"
}

# Git configuration + delta
echo -e "\n${GREEN}Setting up Git...${NC}"
mkdir -p "$HOME/.config/git" "$HOME/.local/bin"
create_link "$DOTFILES_DIR/git" "$HOME/.config/git/custom"
git config --global --get-all include.path | grep -q "custom/common" \
    || git config --global --add include.path "~/.config/git/custom/common.gitconfig"
[[ -f "$HOME/.config/git/themes.gitconfig" ]] \
    || curl -sLo "$HOME/.config/git/themes.gitconfig" \
        "https://raw.githubusercontent.com/dandavison/delta/main/themes.gitconfig"
command -v delta &>/dev/null || "$DOTFILES_DIR/git/install-delta.sh"
create_link "$DOTFILES_DIR/git/git-last" "$HOME/.local/bin/git-last"
create_link "$DOTFILES_DIR/git/git-unpushed" "$HOME/.local/bin/git-unpushed"
create_link "$DOTFILES_DIR/git/git-rebase-unpushed" "$HOME/.local/bin/git-rebase-unpushed"
create_link "$DOTFILES_DIR/git/git-wt-common" "$HOME/.local/bin/git-wt-common"
create_link "$DOTFILES_DIR/git/git-wt-add" "$HOME/.local/bin/git-wt-add"
create_link "$DOTFILES_DIR/git/git-wt-peek" "$HOME/.local/bin/git-wt-peek"
create_link "$DOTFILES_DIR/git/wt-" "$HOME/.local/bin/wt-"

# Utility scripts
echo -e "\n${GREEN}Setting up utility scripts...${NC}"
create_link "$DOTFILES_DIR/scripts/starship-change" "$HOME/.local/bin/starship-change"
create_link "$DOTFILES_DIR/scripts/clean-config-backups" "$HOME/.local/bin/clean-config-backups"
create_link "$DOTFILES_DIR/scripts/screw" "$HOME/.local/bin/screw"
create_link "$DOTFILES_DIR/scripts/brew-install" "$HOME/.local/bin/brew-install"

# Kitty terminal configuration
echo -e "\n${GREEN}Setting up Kitty configuration...${NC}"
create_link "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"

detect_package_managers() {
    local managers=()
    command -v brew &>/dev/null && managers+=("brew")
    command -v nix &>/dev/null && managers+=("nix")
    command -v apt-get &>/dev/null && managers+=("apt")
    command -v dnf &>/dev/null && managers+=("dnf")
    command -v pacman &>/dev/null && managers+=("pacman")
    echo "${managers[@]}"
}

prompt_package_manager() {
    local managers=("$@")
    if [[ ${#managers[@]} -eq 0 ]]; then
        echo -e "${RED}No supported package manager found${NC}" >&2
        return 1
    fi
    if [[ ${#managers[@]} -eq 1 ]]; then
        echo "${managers[0]}"
        return
    fi
    echo -e "${YELLOW}Available package managers:${NC}" >&2
    for i in "${!managers[@]}"; do
        echo "  $((i+1))) ${managers[$i]}" >&2
    done
    local choice
    read -rp "Select [1-${#managers[@]}]: " choice
    if [[ "$choice" -ge 1 && "$choice" -le ${#managers[@]} ]] 2>/dev/null; then
        echo "${managers[$((choice-1))]}"
    else
        echo -e "${RED}Invalid selection${NC}" >&2
        return 1
    fi
}

install_packages() {
    local pm="$1"; shift
    case "$pm" in
        brew)   brew-install "$@" ;;
        nix)
            local pkgs=()
            for p in "$@"; do pkgs+=("nixpkgs#$p"); done
            nix profile install "${pkgs[@]}"
            ;;
        apt)    sudo apt-get update -qq && sudo apt-get install -y "$@" ;;
        dnf)    sudo dnf install -y "$@" ;;
        pacman) sudo pacman -S --needed "$@" ;;
    esac
}

resolve_pkg() {
    local pm="$1" pkg="$2"
    case "$pkg" in
        fd)
            [[ "$pm" == apt || "$pm" == dnf ]] && echo "fd-find" || echo "fd" ;;
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
        *) echo "$pkg" ;;
    esac
}

resolve_all_pkgs() {
    local pm="$1"; shift
    local result=()
    for pkg in "$@"; do
        local resolved
        resolved=$(resolve_pkg "$pm" "$pkg")
        [[ -n "$resolved" ]] && result+=($resolved)
    done
    echo "${result[*]}"
}

pkg_to_bin() {
    case "$1" in
        neovim)                          echo "nvim" ;;
        ripgrep)                         echo "rg" ;;
        fd|fd-find)                      echo "fd" ;;
        tree-sitter|tree-sitter-cli)     echo "tree-sitter" ;;
        node|nodejs)                     echo "node" ;;
        npm)                             echo "npm" ;;
        build-essential|base-devel|gcc)  echo "cc" ;;
        make)                            echo "make" ;;
        *)                               echo "$1" ;;
    esac
}

detect_source() {
    local bin_path
    bin_path="$(command -v "$1" 2>/dev/null)" || return 1
    case "$bin_path" in
        /nix/*|*/.nix-profile/*)            echo "nix" ;;
        /opt/homebrew/*|/usr/local/Cellar/*) echo "brew" ;;
        /usr/bin/*|/bin/*)                  echo "system" ;;
        *)                                  echo "PATH" ;;
    esac
}

REQUIRED_PACKAGES=(neovim ripgrep fd tree-sitter node direnv build-tools)

echo -e "\n${GREEN}Package installation${NC}"
read -ra managers <<< "$(detect_package_managers)"
pm=$(prompt_package_manager "${managers[@]}") && {
    read -ra resolved <<< "$(resolve_all_pkgs "$pm" "${REQUIRED_PACKAGES[@]}")"
    installed=()
    missing=()
    for pkg in "${resolved[@]}"; do
        bin=$(pkg_to_bin "$pkg")
        if source=$(detect_source "$bin"); then
            installed+=("$pkg ($source)")
        else
            missing+=("$pkg")
        fi
    done

    if [[ ${#installed[@]} -gt 0 ]]; then
        echo -e "${GREEN}Already installed:${NC}"
        for pkg in "${installed[@]}"; do
            echo -e "  ${GREEN}✓${NC} $pkg"
        done
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${YELLOW}To install (${pm}):${NC}"
        for pkg in "${missing[@]}"; do
            echo "  - $pkg"
        done
        echo ""
        read -rp "Install these packages? [y/N]: " confirm
        if [[ "$confirm" == [yY] ]]; then
            install_packages "$pm" "${missing[@]}"
            if [[ "$pm" == "apt" || "$pm" == "dnf" ]]; then
                npm i -g tree-sitter-cli
            fi
        fi
    else
        echo -e "${GREEN}All packages already installed${NC}"
    fi
}

echo -e "\n${GREEN}Setting up Neovim configuration...${NC}"
create_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

# Starship prompt configuration
echo -e "\n${GREEN}Starship configurations available in $DOTFILES_DIR/starship/${NC}"
echo -e "${YELLOW}Use 'starship-change $DOTFILES_DIR/starship/<theme>.toml' to select a starship theme${NC}"

# TMux configuration
echo -e "\n${GREEN}Setting up TMux configuration...${NC}"
create_link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
create_link "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"

# Linux-specific configurations (Hyprland, Waybar, Rofi)
if [[ "$OSTYPE" != "darwin"* ]]; then
    # Hyprland configuration
    echo -e "\n${GREEN}Setting up Hyprland configuration...${NC}"
    create_link "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"
    
    # Waybar configuration
    echo -e "\n${GREEN}Setting up Waybar configuration...${NC}"
    create_link "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"
    
    # Rofi configuration
    echo -e "\n${GREEN}Setting up Rofi configuration...${NC}"
    create_link "$DOTFILES_DIR/rofi" "$HOME/.config/rofi"
    
    # SDDM configuration
    echo -e "\n${GREEN}Setting up SDDM configuration...${NC}"
    sudo cp -r "$DOTFILES_DIR/sddm/monochrome" "/usr/share/sddm/themes/"
    sudo cp "$DOTFILES_DIR/sddm/sddm.conf" "/etc/sddm.conf"
    
    echo -e "${GREEN}SDDM monochrome theme installed with Wayland support${NC}"
fi

# Zsh configuration
echo -e "\n${GREEN}Setting up Zsh configuration...${NC}"
create_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"

# macOS specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n${GREEN}Setting up macOS configurations...${NC}"
    
    # Raycast configuration (if Raycast is installed)
    if [[ -d "$HOME/Library/Application Support/com.raycast.macos" ]]; then
        create_link "$DOTFILES_DIR/macos/raycast.rayconfig" "$HOME/Library/Application Support/com.raycast.macos/raycast.rayconfig"
    else
        echo -e "${YELLOW}Raycast not found, skipping Raycast configuration${NC}"
    fi
fi

echo -e "\n${GREEN} Dotfiles setup complete!${NC}"
echo -e "${YELLOW}Note: You may need to restart your terminal or reload configurations for changes to take effect.${NC}"

# Optional: Source common shell configurations if they exist
if [[ -f "$HOME/.bashrc" ]]; then
    echo -e "${GREEN}Reloading ~/.bashrc${NC}"
    source "$HOME/.bashrc"
fi

if [[ -f "$HOME/.zshrc" ]]; then
    echo -e "${GREEN}Reloading ~/.zshrc${NC}"
    source "$HOME/.zshrc"
fi