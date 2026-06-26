# Alacritty

GPU-accelerated terminal emulator configuration.

## Files

| File | Purpose |
|---|---|
| `alacritty.toml` | Main configuration |
| `themes/` | Color scheme variants |

## Highlights

- **Theme**: Tokyo Night (Catppuccin, Nord, Dracula, Gruvbox, Monochrome also available)
- **Font**: FiraCode Nerd Font, 12pt
- **Opacity**: 0.92
- **Scrollback**: 50,000 lines
- **Shell**: Auto-launches tmux (`tmux new-session -A -s main`)
- **Window**: 140×35, dynamic padding, dark decorations

## Keyboard Shortcuts

| Key | Action |
|---|---|
| `Ctrl+Shift+V` | Paste |
| `Ctrl+Shift+C` | Copy |
| `Ctrl+Shift+N` | New instance |
| `Ctrl+Shift+F` | Search forward |
| `Ctrl+Shift+B` | Search backward |
| `Ctrl+Shift+Q` | Quit |
| `Ctrl+L` | Toggle fullscreen |
| `Ctrl+=` / `Ctrl++` | Increase font size |
| `Ctrl+-` | Decrease font size |
| `Ctrl+0` | Reset font size |
| `Shift+↑` / `Shift+↓` | Scroll line (when not in tmux) |
| `Shift+PageUp` / `Shift+PageDown` | Scroll page (when not in tmux) |

> **Note**: Keyboard scroll bindings only work outside tmux. Inside tmux, use `Ctrl-x [` to enter copy mode.

## Mouse

| Button | Action |
|---|---|
| Middle click | Paste selection |
| Right click | Expand selection |

## Deploy

```bash
ln -sf "$HOME/projs/dotfiles/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
cp -r "$HOME/projs/dotfiles/alacritty/themes" "$HOME/.config/alacritty/"
```
