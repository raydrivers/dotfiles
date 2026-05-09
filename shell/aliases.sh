export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

if ls --color=auto / &>/dev/null; then
    alias ls='ls --color=auto'
fi

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
codex() {
    profile="$(<.codex/.profile)"
    case "$profile" in
        strict|readonly|research)
            permissions="strict"
            ;;
        workspace)
            permissions=":workspace"
            ;;
        workspace_web)
            permissions="workspace_web"
            ;;
        idontcare)
            permissions=":workspace"
            ;;
    esac

    printf 'codex profile: %s\n' "$profile"
    command codex --profile "$profile" \
        -c "default_permissions=$permissions" "$@"
}
