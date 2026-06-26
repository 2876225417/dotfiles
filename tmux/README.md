# tmux

Terminal multiplexer — Neovim-aligned keybindings, Catppuccin-themed status bar.

## Files

| File | Purpose |
|---|---|
| `tmux.conf` | Main tmux configuration |
| `which-key-config.yaml` | which-key popup menu layout |
| `scripts/install_plugins.sh` | One-shot plugin installer |
| `scripts/cpu_info.sh` | CPU usage (status bar) |
| `scripts/memory_info.sh` | Memory usage (status bar) |
| `scripts/gpu_info.sh` | GPU usage (status bar) |
| `scripts/disk_info.sh` | Disk usage (status bar) |
| `scripts/network_info.sh` | Network info (status bar) |
| `scripts/system_info.sh` | System info (status bar) |
| `scripts/load_info.sh` | Load average (status bar) |

## Prefix Key

`Ctrl-x` (rebound from default `Ctrl-b`)

Pressing prefix shows a **which-key popup** with all available bindings.

## Keybindings — Pane Management

| Key | Action | Neovim equivalent |
|---|---|---|
| `Ctrl-x` `h/j/k/l` | Focus pane left/down/up/right | `<Leader>h/j/k/l` |
| `Ctrl-x` `s` `h` | Split top/bottom | `<Leader>sh` / `:split` |
| `Ctrl-x` `s` `v` | Split left/right | `<Leader>sv` / `:vsplit` |
| `Ctrl-x` `x` | Kill pane (confirm) | — |
| `Ctrl-x` `z` | Toggle zoom | — |

## Keybindings — Window Management

| Key | Action |
|---|---|
| `Ctrl-x` `t` | New window (cwd) |
| `Ctrl-x` `w` | Kill window (confirm) |
| `Alt-0`…`Alt-8` | Switch window |
| `Ctrl-Alt-q` / `Ctrl-Alt-e` | Previous / next window |
| `Ctrl-x` `F` | fzf launcher |

## Keybindings — Copy Mode (`Ctrl-x` `[`)

Enter scroll/copy mode, then:

| Key | Action | Neovim equivalent |
|---|---|---|
| `j` / `k` | Line down / up | `j` / `k` |
| `Ctrl-j` / `Ctrl-k` | Fast scroll down / up | `Ctrl-j` / `Ctrl-k` |
| `Ctrl-d` / `Ctrl-u` | Half page down / up | `Ctrl-d` / `Ctrl-u` |
| `Ctrl-f` / `Ctrl-b` | Page down / up | `Ctrl-f` / `Ctrl-b` |
| `g` / `G` | Top / bottom | `gg` / `G` |
| `H` / `L` | Start / end of line | `H` / `L` |
| `w` / `b` | Next / previous word | `w` / `b` |
| `v` | Begin selection | `v` |
| `V` | Select line | `V` |
| `Ctrl-v` | Block selection | `Ctrl-v` |
| `y` | Copy & exit | `y` |
| `Y` | Copy line | `Y` |
| `Ctrl-c` | Copy to system clipboard | `Ctrl-c` |
| `/` / `?` | Search down / up | `/` / `?` |
| `n` / `N` | Next / previous match | `n` / `N` |
| `q` | Exit copy mode | — |

## Plugins

| Plugin | Purpose |
|---|---|
| `tmux-plugins/tpm` | Plugin manager |
| `tmux-plugins/tmux-sensible` | Sensible defaults |
| `tmux-plugins/tmux-resurrect` | Save/restore sessions |
| `tmux-plugins/tmux-continuum` | Auto-save + boot restore |
| `tmux-plugins/tmux-yank` | System clipboard |
| `tmux-plugins/tmux-copycat` | Regex search in copy mode |
| `tmux-plugins/tmux-prefix-highlight` | Prefix indicator |
| `tmux-plugins/tmux-pain-control` | Extra pane shortcuts |
| `tmux-plugins/tmux-cpu` | CPU in status bar |
| `tmux-plugins/tmux-battery` | Battery in status bar |
| `sainnhe/tmux-fzf` | Fuzzy finder |
| `nhdaly/tmux-better-mouse-mode` | Improved mouse scroll |
| `alexwforsythe/tmux-which-key` | Popup keybinding menu |

## Deploy

```bash
# Link config
ln -sf "$HOME/projs/dotfiles/tmux/tmux.conf" "$HOME/.tmux.conf"

# Copy scripts
mkdir -p "$HOME/.tmux/scripts"
cp "$HOME/projs/dotfiles/tmux/scripts/"*.sh "$HOME/.tmux/scripts/"

# Install plugins
bash "$HOME/projs/dotfiles/tmux/scripts/install_plugins.sh"

# Reload
tmux source-file ~/.tmux.conf
```
