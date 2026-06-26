#!/usr/bin/env bash
#
# install.sh — Alacritty setup
# Installs alacritty, required fonts, and deploys config + themes.
#

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)"
ALACRITTY_SRC="$DOTFILES_DIR/alacritty"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"

# ----- helpers ---------------------------------------------------------------
info()   { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
ok()     { printf '\033[1;32m[OK]\033[0m   %s\n' "$*"; }
warn()   { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err()    { printf '\033[1;31m[ERR]\033[0m  %s\n' "$*"; }
step()   { printf '\n\033[1;36m==>\033[0m \033[1m%s\033[0m\n' "$*"; }

# ----- detect package manager ------------------------------------------------
detect_pkg_manager() {
    if command -v pacman &>/dev/null; then
        echo "pacman"
    elif command -v apt &>/dev/null; then
        echo "apt"
    elif command -v dnf &>/dev/null; then
        echo "dnf"
    elif command -v zypper &>/dev/null; then
        echo "zypper"
    elif command -v brew &>/dev/null; then
        echo "brew"
    else
        echo "unknown"
    fi
}

PKG=$(detect_pkg_manager)

# ----- install alacritty -----------------------------------------------------
step "Installing Alacritty"

if command -v alacritty &>/dev/null; then
    ok "alacritty $(alacritty --version 2>&1 | head -1) already installed"
else
    info "Installing alacritty via $PKG ..."
    case "$PKG" in
        pacman) sudo pacman -S --noconfirm alacritty ;;
        apt)    sudo apt install -y alacritty ;;
        dnf)    sudo dnf install -y alacritty ;;
        zypper) sudo zypper install -y alacritty ;;
        brew)   brew install --cask alacritty ;;
        *)
            err "Unsupported package manager. Please install alacritty manually:"
            err "  https://alacritty.org/"
            ;;
    esac
    ok "alacritty installed"
fi

# ----- install font ----------------------------------------------------------
step "Installing FiraCode Nerd Font"

FONT_INSTALLED=false
if fc-list 2>/dev/null | grep -qi "FiraCode.*Nerd"; then
    ok "FiraCode Nerd Font already installed"
    FONT_INSTALLED=true
fi

if ! $FONT_INSTALLED; then
    case "$PKG" in
        pacman)
            info "Installing via pacman ..."
            sudo pacman -S --noconfirm ttf-firacode-nerd 2>/dev/null && FONT_INSTALLED=true
            ;;
        apt)
            info "Installing via apt ..."
            sudo apt install -y fonts-firacode 2>/dev/null && FONT_INSTALLED=true
            ;;
        *)
            ;;
    esac
fi

if ! $FONT_INSTALLED; then
    # Manual download from Nerd Fonts GitHub
    FONT_VERSION="3.3.0"
    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v${FONT_VERSION}/FiraCode.zip"
    FONT_DIR="$HOME/.local/share/fonts/FiraCodeNerdFont"

    info "Downloading FiraCode Nerd Font v${FONT_VERSION} ..."
    mkdir -p "$FONT_DIR"
    curl -fsSL "$FONT_URL" -o /tmp/FiraCodeNerdFont.zip
    unzip -qo /tmp/FiraCodeNerdFont.zip -d "$FONT_DIR"
    rm -f /tmp/FiraCodeNerdFont.zip
    fc-cache -fv &>/dev/null
    ok "FiraCode Nerd Font installed to $FONT_DIR"
fi

# ----- deploy config ---------------------------------------------------------
step "Deploying Alacritty config"

mkdir -p "$CONFIG_DIR"

info "Linking alacritty.toml ..."
ln -sf "$ALACRITTY_SRC/alacritty.toml" "$CONFIG_DIR/alacritty.toml"
ok "alacritty.toml → $CONFIG_DIR/alacritty.toml"

info "Deploying themes ..."
mkdir -p "$CONFIG_DIR/themes"
cp "$ALACRITTY_SRC/themes/"*.toml "$CONFIG_DIR/themes/"
ok "$(ls "$ALACRITTY_SRC/themes/"*.toml | wc -l) themes → $CONFIG_DIR/themes/"

# ----- optional: fcitx -------------------------------------------------------
step "Checking input method (fcitx)"

if command -v fcitx5 &>/dev/null; then
    ok "fcitx5 found — input method env vars are configured in alacritty.toml"
elif command -v fcitx &>/dev/null; then
    ok "fcitx found — input method env vars are configured in alacritty.toml"
else
    warn "fcitx not found. If you need CJK input, install fcitx5:"
    warn "  sudo pacman -S fcitx5 fcitx5-configtool fcitx5-gtk fcitx5-qt"
fi

# ----- done ------------------------------------------------------------------
echo
info "Alacritty setup complete."
info "Config:  $CONFIG_DIR/alacritty.toml"
info "Themes:  $CONFIG_DIR/themes/"
info "Font:    FiraCode Nerd Font (12pt)"
