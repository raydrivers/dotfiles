#!/bin/bash

# Clean backup files created by setup.sh

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

search_dirs=("$@")
if [[ ${#search_dirs[@]} -eq 0 ]]; then
    # Directories where setup.sh creates symlinks
    search_dirs=(
        "$HOME/.config"
        "$HOME/.local/bin"
    )
    # $HOME itself for .zshrc, .bashrc, .tmux.conf
    # (maxdepth 1 via separate find below)
fi

echo "Searching for backup files..."

backups=()
while IFS= read -r line; do
    backups+=("$line")
done < <(
    find "$HOME" -maxdepth 1 \
        -name "*.backup.*" \
        \( -type f -o -type l \) \
        2>/dev/null
    find "${search_dirs[@]}" \
        -name "*.backup.*" \
        \( -type f -o -type l -o -type d \) \
        2>/dev/null
)

if [[ ${#backups[@]} -eq 0 ]]; then
    echo -e "${GREEN}No backup files found${NC}"
    exit 0
fi

echo -e "${YELLOW}Found backup files:${NC}"
for f in "${backups[@]}"; do
    echo "  $f"
done

echo
echo "Total: ${#backups[@]} backup files"
echo

read -rp "Delete these backup files? [y/N]: " confirm
if [[ "$confirm" != [yY] ]]; then
    echo -e "${YELLOW}Cancelled${NC}"
    exit 0
fi

deleted=0
for f in "${backups[@]}"; do
    if rm -rf "$f"; then
        echo -e "  ${GREEN}✓${NC} $f"
        ((deleted++)) || true
    else
        echo -e "  ${RED}✗${NC} $f"
    fi
done

echo -e "\n${GREEN}Deleted $deleted backup files${NC}"
