#!/bin/bash

# Dotfiles cleanup script
# Removes symlinks created by setup.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Cleaning up dotfiles symlinks...${NC}"

# Function to remove symlink and restore backup if exists
remove_link() {
    local target="$1"
    
    if [[ -L "$target" ]]; then
        echo -e "${GREEN}✓${NC} Removing symlink: $target"
        rm "$target"
        
        # Look for most recent backup and restore it
        local backup=$(ls -t "${target}.backup."* 2>/dev/null | head -1)
        if [[ -n "$backup" ]]; then
            echo -e "${GREEN}↺${NC} Restoring backup: $backup -> $target"
            mv "$backup" "$target"
        fi
    elif [[ -e "$target" ]]; then
        echo -e "${YELLOW}⚠${NC} Skipping non-symlink: $target"
    else
        echo -e "${YELLOW}?${NC} Not found: $target"
    fi
}

# Function to clean up remaining backup files
clean_backups() {
    local target="$1"
    local backups=("${target}.backup."*)
    
    for backup in "${backups[@]}"; do
        if [[ -e "$backup" ]]; then
            echo -e "${RED}🗑${NC} Removing backup: $backup"
            rm -rf "$backup"
        fi
    done
}

# Git configuration
echo -e "\n${GREEN}Cleaning up Git configuration...${NC}"
remove_link "$HOME/.config/git/aliases.gitconfig"

# Git helper scripts
echo -e "\n${GREEN}Cleaning up Git helper scripts...${NC}"
remove_link "$HOME/.local/bin/git-last"
remove_link "$HOME/.local/bin/git-unpushed"
remove_link "$HOME/.local/bin/git-rebase-unpushed"
remove_link "$HOME/.local/bin/git-wt-common"
remove_link "$HOME/.local/bin/git-wt-add"
remove_link "$HOME/.local/bin/git-wt-peek"
remove_link "$HOME/.local/bin/wt-"

# Utility scripts
echo -e "\n${GREEN}Cleaning up utility scripts...${NC}"
remove_link "$HOME/.local/bin/starship-change"
remove_link "$HOME/.local/bin/clean-config-backups"

# Kitty terminal configuration
echo -e "\n${GREEN}Cleaning up Kitty configuration...${NC}"
remove_link "$HOME/.config/kitty"

# Neovim configuration
echo -e "\n${GREEN}Cleaning up Neovim configuration...${NC}"
remove_link "$HOME/.config/nvim"

# TMux configuration
echo -e "\n${GREEN}Cleaning up TMux configuration...${NC}"
remove_link "$HOME/.tmux.conf"
remove_link "$HOME/.config/tmux"

# Linux-specific configurations
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "\n${GREEN}Cleaning up Linux configurations...${NC}"
    remove_link "$HOME/.config/hypr"
    remove_link "$HOME/.config/waybar"
    remove_link "$HOME/.config/rofi"
    
    echo -e "${YELLOW}Note: SDDM configuration requires manual removal:${NC}"
    echo -e "  sudo rm -rf /usr/share/sddm/themes/monochrome"
    echo -e "  sudo rm /etc/sddm.conf"
fi

# Zsh configuration
echo -e "\n${GREEN}Cleaning up Zsh configuration...${NC}"
remove_link "$HOME/.zshrc"

# macOS specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n${GREEN}Cleaning up macOS configurations...${NC}"
    remove_link "$HOME/Library/Application Support/com.raycast.macos/raycast.rayconfig"
fi

# Optional: Clean up all remaining backup files
read -p "$(echo -e "\n${YELLOW}Remove all remaining backup files? (y/N): ${NC}")" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo -e "\n${GREEN}Cleaning up remaining backup files...${NC}"
    
    clean_backups "$HOME/.config/git/aliases.gitconfig"
    clean_backups "$HOME/.local/bin/git-last"
    clean_backups "$HOME/.local/bin/git-unpushed"
    clean_backups "$HOME/.local/bin/git-rebase-unpushed"
    clean_backups "$HOME/.local/bin/git-wt-common"
    clean_backups "$HOME/.local/bin/git-wt-add"
    clean_backups "$HOME/.local/bin/git-wt-peek"
    clean_backups "$HOME/.local/bin/wt-"
    clean_backups "$HOME/.local/bin/starship-change"
    clean_backups "$HOME/.local/bin/clean-config-backups"
    clean_backups "$HOME/.config/kitty"
    clean_backups "$HOME/.config/nvim"
    clean_backups "$HOME/.tmux.conf"
    clean_backups "$HOME/.config/tmux"
    clean_backups "$HOME/.zshrc"
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        clean_backups "$HOME/.config/hypr"
        clean_backups "$HOME/.config/waybar"
        clean_backups "$HOME/.config/rofi"
    fi
    
    if [[ "$OSTYPE" == "darwin"* ]]; then
        clean_backups "$HOME/Library/Application Support/com.raycast.macos/raycast.rayconfig"
    fi
fi

echo -e "\n${GREEN}✓ Dotfiles cleanup complete!${NC}"