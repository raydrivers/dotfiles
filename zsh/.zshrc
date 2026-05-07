HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
HISTFILESIZE=100000
SAVEHIST=10000
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt HIST_SAVE_NO_DUPS

autoload -U colors && colors

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export DOTFILES_DIR="$HOME/dotfiles"
source "$DOTFILES_DIR/shell/.profile"

if [[ -n "$KITTY_INSTALLATION_DIR" ]]; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi

command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

bindkey -e  # Use emacs keymap for line editing (Ctrl+A, Ctrl+E, etc.)
bindkey '^R' history-incremental-search-backward
