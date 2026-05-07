#!/bin/bash

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
. "$DOTFILES_DIR/scripts/setup-lib.sh"

lnk "hypr" "$HOME/.config/hypr"
lnk "waybar" "$HOME/.config/waybar"
lnk "rofi" "$HOME/.config/rofi"

# SDDM reads system-owned paths before user dotfiles are available.
# TODO: double-check the issue, I don't remember the exact problem
sudo cp -r "$DOTFILES_DIR/sddm/monochrome" /usr/share/sddm/themes/
sudo cp "$DOTFILES_DIR/sddm/sddm.conf" /etc/sddm.conf
