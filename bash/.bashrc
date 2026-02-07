HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend histverify

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

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

[ -f /nix/var/nix/profiles/default/etc/profile.d/nix.sh ] && source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
[ -f ~/.posix-profile ] && source ~/.posix-profile

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

command -v starship &>/dev/null && eval "$(starship init bash)"
command -v direnv &>/dev/null && eval "$(direnv hook bash)"
