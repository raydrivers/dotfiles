# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_VERIFY SHARE_HISTORY

# Colors
autoload -U colors && colors
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

# Conditional includes
[ -f /nix/var/nix/profiles/default/etc/profile.d/nix.sh ] && source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
[ -f ~/.posix-profile ] && source ~/.posix-profile

