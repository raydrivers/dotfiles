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

# Git configuration
echo -e "\n${GREEN}Setting up Git configuration...${NC}"
create_link "$DOTFILES_DIR/git/aliases.gitconfig" "$HOME/.config/git/aliases.gitconfig"

# Git helper scripts
echo -e "\n${GREEN}Setting up Git helper scripts...${NC}"
mkdir -p "$HOME/.local/bin"
create_link "$DOTFILES_DIR/git/git-last" "$HOME/.local/bin/git-last"
create_link "$DOTFILES_DIR/git/git-unpushed" "$HOME/.local/bin/git-unpushed"
create_link "$DOTFILES_DIR/git/git-rebase-unpushed" "$HOME/.local/bin/git-rebase-unpushed"

# Utility scripts
echo -e "\n${GREEN}Setting up utility scripts...${NC}"
create_link "$DOTFILES_DIR/scripts/starship-change" "$HOME/.local/bin/starship-change"
create_link "$DOTFILES_DIR/scripts/clean-config-backups" "$HOME/.local/bin/clean-config-backups"

# Kitty terminal configuration
echo -e "\n${GREEN}Setting up Kitty configuration...${NC}"
create_link "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"

# Neovim configuration
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