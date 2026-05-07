source "$DOTFILES_DIR/shell/env.sh"
source "$DOTFILES_DIR/shell/aliases.sh"
source "$DOTFILES_DIR/shell/git.sh"

if [ "$(uname -s)" = "Darwin" ]; then
    source "$DOTFILES_DIR/shell/macos.sh"
fi

if [ -f /nix/var/nix/profiles/default/etc/profile.d/nix.sh ]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
fi

# Computer-specific configuration
if [ -f "$HOME/.posix-profile" ]; then
    source "$HOME/.posix-profile"
fi
