#!/usr/bin/env bash
#
# install_tmux_plugins.sh
# Installs TPM (tmux plugin manager) and all plugins defined in ~/.tmux.conf
#

set -euo pipefail

TPM_DIR="$HOME/.tmux/plugins/tpm"
TMUX_CONF="$HOME/.tmux.conf"
DOTFILES_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

# ----- helpers ---------------------------------------------------------------
info()  { printf '\033[1;34m[INFO]\033[0m %s\n' "$*"; }
ok()    { printf '\033[1;32m[OK]\033[0m   %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m %s\n' "$*"; }
err()   { printf '\033[1;31m[ERR]\033[0m  %s\n' "$*"; }

# ----- pre-flight -----------------------------------------------------------
if ! command -v tmux &>/dev/null; then
    err "tmux is not installed — please install tmux >= 3.2 first"
    exit 1
fi

TMUX_VER=$(tmux -V | grep -oP '\d+\.\d+')
info "tmux version: $TMUX_VER"

if [[ ! -f "$TMUX_CONF" ]]; then
    err "$TMUX_CONF not found — nothing to install plugins from"
    exit 1
fi

# ----- install tpm -----------------------------------------------------------
if [[ -f "$TPM_DIR/tpm" ]]; then
    ok "TPM already installed at $TPM_DIR"
else
    info "Cloning TPM into $TPM_DIR ..."
    mkdir -p "$(dirname "$TPM_DIR")"
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    ok "TPM installed"
fi

# ----- install plugins -------------------------------------------------------
info "Installing plugins listed in $TMUX_CONF ..."
"$TPM_DIR/bin/install_plugins" || true

ok "All plugins installed"

# ----- deploy which-key config -----------------------------------------------
WHICH_KEY_SRC="$DOTFILES_DIR/tmux/which-key-config.yaml"
WHICH_KEY_DST="$HOME/.tmux/plugins/tmux-which-key/config.yaml"
if [[ -f "$WHICH_KEY_SRC" ]]; then
    info "Deploying which-key config ..."
    mkdir -p "$(dirname "$WHICH_KEY_DST")"
    cp "$WHICH_KEY_SRC" "$WHICH_KEY_DST"
    ok "which-key config deployed"
fi

# ----- deploy status bar scripts ---------------------------------------------
SCRIPTS_SRC="$DOTFILES_DIR/tmux/scripts"
SCRIPTS_DST="$HOME/.tmux/scripts"
info "Deploying status bar scripts to $SCRIPTS_DST ..."
mkdir -p "$SCRIPTS_DST"
for f in "$SCRIPTS_SRC"/*.sh; do
    name=$(basename "$f")
    [[ "$name" == "install_plugins.sh" ]] && continue
    cp "$f" "$SCRIPTS_DST/$name"
done
ok "Status bar scripts deployed"

# ----- reload tmux -----------------------------------------------------------
if [[ -n "${TMUX:-}" ]]; then
    info "Reloading tmux config in current session ..."
    tmux source-file "$TMUX_CONF" 2>/dev/null || true
    ok "tmux config reloaded"
else
    info "Not inside tmux session — skip reload (plugins will load on next tmux start)"
fi

echo
info "Done. Start a new tmux session or reload with: tmux source-file ~/.tmux.conf"
