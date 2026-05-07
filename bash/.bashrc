HISTFILE=~/.bash_history
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend histverify

export MSYS=winsymlinks:nativestrict

export DOTFILES_DIR="$HOME/dotfiles"
source "$DOTFILES_DIR/shell/.profile"

command -v starship &>/dev/null && eval "$(starship init bash)"
command -v direnv &>/dev/null && eval "$(direnv hook bash)"
