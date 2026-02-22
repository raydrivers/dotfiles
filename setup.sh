#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

detect_environment() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -n "$WSL_DISTRO_NAME" ]] || grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "mingw"* ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

ENV_TYPE=$(detect_environment)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Enable real symlinks on Windows (MSYS/Git Bash defaults to copies)
[[ "$ENV_TYPE" == "windows" ]] && export MSYS=winsymlinks:nativestrict

echo -e "${GREEN}Environment: ${ENV_TYPE}${NC}"
echo -e "${GREEN}Dotfiles: ${DOTFILES_DIR}${NC}"

create_link() {
    local source="$1" target="$2"
    mkdir -p "$(dirname "$target")"
    if [[ -e "$target" || -L "$target" ]]; then
        echo -e "${YELLOW}Backing up $target${NC}"
        mv "$target" "${target}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    ln -sf "$source" "$target"
    echo -e "${GREEN}✓${NC} $target"
}

install_nvm() {
    [[ -d "$HOME/.nvm" ]] && { echo -e "${GREEN}✓${NC} nvm"; return 0; }
    echo -e "${YELLOW}Installing nvm...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

install_node_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    command -v node &>/dev/null && { echo -e "${GREEN}✓${NC} Node $(node --version)"; return 0; }
    echo -e "${YELLOW}Installing Node LTS...${NC}"
    nvm install --lts
    nvm alias default 'lts/*'
    echo -e "${GREEN}✓${NC} Node $(node --version)"
}

echo -e "\n${GREEN}Setting up Git...${NC}"
mkdir -p "$HOME/.config/git" "$HOME/.local/bin"
create_link "$DOTFILES_DIR/git" "$HOME/.config/git/custom"
git config --global --get-all include.path | grep -q "custom/common" \
    || git config --global --add include.path "~/.config/git/custom/common.gitconfig"
[[ -f "$HOME/.config/git/themes.gitconfig" ]] \
    || curl -sLo "$HOME/.config/git/themes.gitconfig" \
        "https://raw.githubusercontent.com/dandavison/delta/main/themes.gitconfig"
command -v delta &>/dev/null || "$DOTFILES_DIR/git/install-delta.sh"
create_link "$DOTFILES_DIR/git/git-last" "$HOME/.local/bin/git-last"
create_link "$DOTFILES_DIR/git/git-unpushed" "$HOME/.local/bin/git-unpushed"
create_link "$DOTFILES_DIR/git/git-rebase-unpushed" "$HOME/.local/bin/git-rebase-unpushed"
create_link "$DOTFILES_DIR/git/git-wt-common" "$HOME/.local/bin/git-wt-common"
create_link "$DOTFILES_DIR/git/git-wt-add" "$HOME/.local/bin/git-wt-add"
create_link "$DOTFILES_DIR/git/git-wt-peek" "$HOME/.local/bin/git-wt-peek"


echo -e "\n${GREEN}Setting up utility scripts...${NC}"
create_link "$DOTFILES_DIR/scripts/starship-change" "$HOME/.local/bin/starship-change"
create_link "$DOTFILES_DIR/scripts/clean-config-backups" "$HOME/.local/bin/clean-config-backups"
if [[ "$ENV_TYPE" != "windows" ]]; then
    create_link "$DOTFILES_DIR/scripts/screw" "$HOME/.local/bin/screw"
    create_link "$DOTFILES_DIR/scripts/brew-install" "$HOME/.local/bin/brew-install"
fi
create_link "$DOTFILES_DIR/scripts/dev" "$HOME/.local/bin/dev"
create_link "$DOTFILES_DIR/scripts/dev-init" "$HOME/.local/bin/dev-init"

if [[ "$ENV_TYPE" != "windows" ]]; then
    echo -e "\n${GREEN}Setting up Kitty...${NC}"
    create_link "$DOTFILES_DIR/kitty" "$HOME/.config/kitty"
fi

detect_package_managers() {
    local managers=()
    command -v brew &>/dev/null && managers+=("brew")
    command -v nix &>/dev/null && managers+=("nix")
    command -v apt-get &>/dev/null && managers+=("apt")
    command -v dnf &>/dev/null && managers+=("dnf")
    command -v pacman &>/dev/null && managers+=("pacman")
    command -v winget.exe &>/dev/null && managers+=("winget")
    echo "${managers[@]}"
}

prompt_package_manager() {
    local managers=("$@")
    if [[ ${#managers[@]} -eq 0 ]]; then
        echo -e "${RED}No supported package manager found${NC}" >&2
        return 1
    fi
    if [[ ${#managers[@]} -eq 1 ]]; then
        echo "${managers[0]}"
        return
    fi
    echo -e "${YELLOW}Available package managers:${NC}" >&2
    for i in "${!managers[@]}"; do
        echo "  $((i+1))) ${managers[$i]}" >&2
    done
    local choice
    read -rp "Select [1-${#managers[@]}]: " choice
    if [[ "$choice" -ge 1 && "$choice" -le ${#managers[@]} ]] 2>/dev/null; then
        echo "${managers[$((choice-1))]}"
    else
        echo -e "${RED}Invalid selection${NC}" >&2
        return 1
    fi
}

install_packages() {
    local pm="$1"; shift
    case "$pm" in
        brew)   brew-install "$@" ;;
        nix)
            local pkgs=()
            for p in "$@"; do pkgs+=("nixpkgs#$p"); done
            nix profile install "${pkgs[@]}"
            ;;
        apt)    sudo apt-get update -qq && sudo apt-get install -y "$@" ;;
        dnf)    sudo dnf install -y "$@" ;;
        pacman) sudo pacman -S --needed "$@" ;;
        winget) for p in "$@"; do winget.exe install --id "$p" -e --accept-source-agreements --accept-package-agreements; done ;;
    esac
}

resolve_pkg() {
    local pm="$1" pkg="$2"
    if [[ "$pm" == "winget" ]]; then
        case "$pkg" in
            neovim)      echo "Neovim.Neovim" ;;
            ripgrep)     echo "BurntSushi.ripgrep.MSVC" ;;
            fd)          echo "sharkdp.fd" ;;
            direnv)      echo "direnv.direnv" ;;
            tree-sitter) return ;;
            build-tools) return ;;
            node)        return ;;
            *)           echo "$pkg" ;;
        esac
        return
    fi
    case "$pkg" in
        fd)
            [[ "$pm" == apt || "$pm" == dnf ]] && echo "fd-find" || echo "fd" ;;
        node)
            case "$pm" in
                brew) echo "node" ;;
                nix)  echo "nodejs" ;;
                *)    echo "nodejs npm" ;;
            esac ;;
        tree-sitter)
            case "$pm" in
                apt|dnf) return ;;
                pacman)  echo "tree-sitter-cli" ;;
                *)       echo "tree-sitter" ;;
            esac ;;
        build-tools)
            case "$pm" in
                apt)    echo "build-essential" ;;
                dnf)    echo "gcc make" ;;
                pacman) echo "base-devel" ;;
            esac ;;
        *) echo "$pkg" ;;
    esac
}

resolve_all_pkgs() {
    local pm="$1"; shift
    local result=()
    for pkg in "$@"; do
        local resolved
        resolved=$(resolve_pkg "$pm" "$pkg")
        [[ -n "$resolved" ]] && result+=($resolved)
    done
    echo "${result[*]}"
}

pkg_to_bin() {
    case "$1" in
        neovim|Neovim.Neovim)                       echo "nvim" ;;
        ripgrep|BurntSushi.ripgrep.MSVC)             echo "rg" ;;
        fd|fd-find|sharkdp.fd)                       echo "fd" ;;
        tree-sitter|tree-sitter-cli) echo "tree-sitter" ;;
        node|nodejs)                                 echo "node" ;;
        npm)                                         echo "npm" ;;
        build-essential|base-devel|gcc)              echo "cc" ;;
        make)                                        echo "make" ;;
        direnv|direnv.direnv)                        echo "direnv" ;;
        *)                                           echo "$1" ;;
    esac
}

detect_source() {
    local bin_path
    bin_path="$(command -v "$1" 2>/dev/null)" || return 1
    case "$bin_path" in
        /nix/*|*/.nix-profile/*)             echo "nix" ;;
        /opt/homebrew/*|/usr/local/Cellar/*) echo "brew" ;;
        /usr/bin/*|/bin/*)                   echo "system" ;;
        *)                                   echo "PATH" ;;
    esac
}

echo -e "\n${GREEN}Packages${NC}"

if [[ "$ENV_TYPE" == "wsl" || "$ENV_TYPE" == "linux" || "$ENV_TYPE" == "windows" ]]; then
    install_nvm
    install_node_nvm
fi

if command -v starship &>/dev/null; then
    echo -e "${GREEN}✓${NC} starship"
else
    echo -e "${YELLOW}Installing starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh
fi

REQUIRED_PACKAGES=(neovim ripgrep fd tree-sitter direnv build-tools)
[[ "$ENV_TYPE" == "macos" ]] && REQUIRED_PACKAGES+=(node)
read -ra managers <<< "$(detect_package_managers)"
pm=$(prompt_package_manager "${managers[@]}") && {
    read -ra resolved <<< "$(resolve_all_pkgs "$pm" "${REQUIRED_PACKAGES[@]}")"
    installed=()
    missing=()
    for pkg in "${resolved[@]}"; do
        bin=$(pkg_to_bin "$pkg")
        if source=$(detect_source "$bin"); then
            installed+=("$pkg ($source)")
        else
            missing+=("$pkg")
        fi
    done

    if [[ ${#installed[@]} -gt 0 ]]; then
        echo -e "${GREEN}Already installed:${NC}"
        for pkg in "${installed[@]}"; do
            echo -e "  ${GREEN}✓${NC} $pkg"
        done
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
        echo -e "${YELLOW}To install (${pm}):${NC}"
        for pkg in "${missing[@]}"; do
            echo "  - $pkg"
        done
        echo ""
        read -rp "Install these packages? [y/N]: " confirm
        if [[ "$confirm" == [yY] ]]; then
            install_packages "$pm" "${missing[@]}"
            if [[ "$pm" == "apt" || "$pm" == "dnf" || "$pm" == "winget" ]]; then
                command -v tree-sitter &>/dev/null || npm i -g tree-sitter-cli
            fi
        fi
    else
        echo -e "${GREEN}All packages already installed${NC}"
    fi
}

echo -e "\n${GREEN}Configs${NC}"
if [[ "$ENV_TYPE" == "windows" ]]; then
    create_link "$DOTFILES_DIR/nvim" "$HOME/AppData/Local/nvim"
else
    create_link "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
fi

echo -e "${GREEN}Starship themes: $DOTFILES_DIR/starship/${NC}"
echo -e "${YELLOW}Use 'starship-change <theme>.toml' to switch${NC}"
[[ ! -f "$HOME/.config/starship.toml" && ! -L "$HOME/.config/starship.toml" ]] \
    && create_link "$DOTFILES_DIR/starship/simple.toml" "$HOME/.config/starship.toml"

if [[ "$ENV_TYPE" != "windows" ]]; then
    create_link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
    create_link "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"
fi

if [[ "$ENV_TYPE" == "linux" ]]; then
    echo -e "\n${GREEN}Linux Desktop${NC}"
    create_link "$DOTFILES_DIR/hypr" "$HOME/.config/hypr"
    create_link "$DOTFILES_DIR/waybar" "$HOME/.config/waybar"
    create_link "$DOTFILES_DIR/rofi" "$HOME/.config/rofi"
    sudo cp -r "$DOTFILES_DIR/sddm/monochrome" "/usr/share/sddm/themes/"
    sudo cp "$DOTFILES_DIR/sddm/sddm.conf" "/etc/sddm.conf"
fi

if [[ "$ENV_TYPE" == "windows" ]]; then
    echo -e "\n${GREEN}Shell configs (Windows)${NC}"
    create_link "$DOTFILES_DIR/bash/.bashrc" "$HOME/.bashrc"
    PS_PROFILE_DIR="$HOME/Documents/PowerShell"
    mkdir -p "$PS_PROFILE_DIR"
    create_link "$DOTFILES_DIR/powershell/profile.ps1" "$PS_PROFILE_DIR/Microsoft.PowerShell_profile.ps1"
else
    create_link "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
fi

if [[ "$ENV_TYPE" == "macos" ]]; then
    echo -e "\n${GREEN}macOS${NC}"
    [[ -d "$HOME/Library/Application Support/com.raycast.macos" ]] \
        && create_link "$DOTFILES_DIR/macos/raycast.rayconfig" "$HOME/Library/Application Support/com.raycast.macos/raycast.rayconfig"
fi

echo -e "\n${GREEN}✓ Setup complete${NC}"
echo -e "${YELLOW}Restart terminal for changes to take effect${NC}"
