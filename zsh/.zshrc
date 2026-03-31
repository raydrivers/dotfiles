HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY SHARE_HISTORY

autoload -U colors && colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
if ls --color=auto / &>/dev/null; then
    alias ls='ls --color=auto'
fi
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
export DOTFILES_DIR="$HOME/dotfiles"

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
export HOMEBREW_NO_ENV_HINTS=1

brew() {
    if command -v screw &>/dev/null; then
        screw "$@"
    else
        command brew "$@"
    fi
}

git() { . git-wrapper; }

[ -f /nix/var/nix/profiles/default/etc/profile.d/nix.sh ] && source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
[ -f ~/.posix-profile ] && source ~/.posix-profile

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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

