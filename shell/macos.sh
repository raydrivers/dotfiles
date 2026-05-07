export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
export HOMEBREW_NO_ENV_HINTS=1

brew() {
    local confirm
    local side_effects

    case "$1" in
        upgrade) side_effects="upgrades formulae and may rebuild dependents" ;;
        cleanup) side_effects="removes cached downloads and old versions" ;;
        autoremove) side_effects="removes unused dependencies" ;;
        *)
            command brew "$@"
            return
            ;;
    esac

    echo "run screw"
    echo "Command: brew $*"
    echo "Side effects: $side_effects"
    printf "Proceed? [y/N]: "
    read -r confirm

    if [[ "$confirm" != [yY] ]]; then
        echo "Skipped"
        return 0
    fi

    command brew "$@"
}
