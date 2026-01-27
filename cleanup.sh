#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

clean_backups() {
    local target="$1"
    local found=0
    for backup in "${target}.backup."*; do
        [[ -e "$backup" ]] || continue
        echo -e "  ${RED}✗${NC} $backup"
        rm -rf "$backup"
        found=1
    done
    return $((1 - found))
}

TARGETS=(
    "$HOME/.config/git/aliases.gitconfig"
    "$HOME/.local/bin/git-last"
    "$HOME/.local/bin/git-unpushed"
    "$HOME/.local/bin/git-rebase-unpushed"
    "$HOME/.local/bin/git-wt-common"
    "$HOME/.local/bin/git-wt-add"
    "$HOME/.local/bin/git-wt-peek"
    "$HOME/.local/bin/wt-"
    "$HOME/.local/bin/starship-change"
    "$HOME/.local/bin/clean-config-backups"
    "$HOME/.local/bin/screw"
    "$HOME/.local/bin/brew-install"
    "$HOME/.config/kitty"
    "$HOME/.config/nvim"
    "$HOME/.tmux.conf"
    "$HOME/.config/tmux"
    "$HOME/.zshrc"
)

if [[ "$OSTYPE" != "darwin"* ]]; then
    TARGETS+=(
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/rofi"
    )
fi

if [[ "$OSTYPE" == "darwin"* ]]; then
    TARGETS+=("$HOME/Library/Application Support/com.raycast.macos/raycast.rayconfig")
fi

echo -e "${GREEN}Scanning for backup files...${NC}"

found_any=0
for target in "${TARGETS[@]}"; do
    for backup in "${target}.backup."*; do
        if [[ -e "$backup" ]]; then
            found_any=1
            echo "  $backup"
        fi
    done
done

if [[ $found_any -eq 0 ]]; then
    echo -e "${GREEN}No backup files found${NC}"
    exit 0
fi

echo ""
read -rp "$(echo -e "${YELLOW}Remove these backup files? [y/N]: ${NC}")" confirm
if [[ "$confirm" != [yY] ]]; then
    exit 0
fi

for target in "${TARGETS[@]}"; do
    clean_backups "$target" || true
done

echo -e "\n${GREEN}Cleanup complete${NC}"
