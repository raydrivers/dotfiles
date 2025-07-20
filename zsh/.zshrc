# Zsh configuration

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY

# Enable completion system
autoload -Uz compinit
compinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Menu-style completion
zstyle ':completion:*' menu select

# Add .local/bin to PATH
export PATH="$HOME/.local/bin:$PATH"

# Set nvim as default editor
export EDITOR=nvim

# Initialize starship prompt
eval "$(starship init zsh)"