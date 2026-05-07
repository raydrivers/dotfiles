export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

if ls --color=auto / &>/dev/null; then
    alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
