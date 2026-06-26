#!/usr/bin/env bash
#
# install.sh — Zsh setup
# Installs zsh, oh-my-zsh, powerlevel10k, external plugins, and deploys configs.
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
ZSH_SRC="$DOTFILES_DIR/zsh"
ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

# ----- helpers ---------------------------------------------------------------
info()   { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
ok()     { printf '\033[1;32m[OK]\033[0m   %s\n' "$*"; }
warn()   { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err()    { printf '\033[1;31m[ERR]\033[0m  %s\n' "$*"; }
step()   { printf '\n\033[1;36m==>\033[0m \033[1m%s\033[0m\n' "$*"; }

# ----- install zsh -----------------------------------------------------------
step "Installing zsh"

if command -v zsh &>/dev/null; then
    ok "zsh $(zsh --version | awk '{print $2}') already installed"
else
    info "Installing zsh ..."
    if command -v pacman &>/dev/null; then
        sudo pacman -S --noconfirm zsh
    elif command -v apt &>/dev/null; then
        sudo apt install -y zsh
    elif command -v dnf &>/dev/null; then
        sudo dnf install -y zsh
    elif command -v brew &>/dev/null; then
        brew install zsh
    else
        err "Please install zsh manually: https://www.zsh.org/"
        exit 1
    fi
    ok "zsh installed"
fi

# Set zsh as default shell if not already
if [[ "$SHELL" != *"/zsh" ]]; then
    info "Setting zsh as default shell ..."
    chsh -s "$(which zsh)" 2>/dev/null || warn "Could not change shell — run 'chsh -s \$(which zsh)' manually"
fi

# ----- install oh-my-zsh -----------------------------------------------------
step "Installing oh-my-zsh"

if [[ -d "$ZSH" ]]; then
    ok "oh-my-zsh already installed at $ZSH"
else
    info "Installing oh-my-zsh ..."
    RUNZSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" </dev/null
    ok "oh-my-zsh installed"
fi

# ----- install powerlevel10k -------------------------------------------------
step "Installing powerlevel10k theme"

P10K_DIR="$ZSH_CUSTOM/themes/powerlevel10k"
if [[ -f "$P10K_DIR/powerlevel10k.zsh-theme" ]]; then
    ok "powerlevel10k already installed"
else
    info "Cloning powerlevel10k ..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    ok "powerlevel10k installed"
fi

# ----- install external plugins ----------------------------------------------
step "Installing external plugins"

clone_plugin() {
    local name="$1" url="$2" dir="$ZSH_CUSTOM/plugins/$name"
    if [[ -d "$dir/.git" ]]; then
        ok "$name already installed"
    else
        info "Cloning $name ..."
        git clone --depth=1 "$url" "$dir"
        ok "$name installed"
    fi
}

clone_plugin "zsh-autosuggestions"      "https://github.com/zsh-users/zsh-autosuggestions"
clone_plugin "zsh-syntax-highlighting"  "https://github.com/zsh-users/zsh-syntax-highlighting.git"

# ----- deploy configs --------------------------------------------------------
step "Deploying zsh configs"

info "Linking zshrc ..."
ln -sf "$ZSH_SRC/zshrc" "$HOME/.zshrc"
ok "zshrc → ~/.zshrc"

info "Linking p10k.zsh ..."
ln -sf "$ZSH_SRC/p10k.zsh" "$HOME/.p10k.zsh"
ok "p10k.zsh → ~/.p10k.zsh"

info "Deploying custom plugins ..."
mkdir -p "$ZSH_CUSTOM/plugins"
for plugin_dir in "$ZSH_SRC/plugins/"*/; do
    name=$(basename "$plugin_dir")
    cp -r "$plugin_dir" "$ZSH_CUSTOM/plugins/$name"
    ok "plugin: $name"
done

# ----- done ------------------------------------------------------------------
echo
info "Zsh setup complete."
info "Config:     ~/.zshrc"
info "p10k theme: ~/.p10k.zsh"
info "Plugins:    $ZSH_CUSTOM/plugins/"
echo
info "Start a new terminal or run: exec zsh"
