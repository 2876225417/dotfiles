# dotfiles

Personal configuration files, organized by application.

```
dotfiles/
├── alacritty/          # Alacritty terminal emulator
│   ├── alacritty.toml
│   └── themes/
├── tmux/               # tmux multiplexer
│   ├── tmux.conf
│   ├── which-key-config.yaml
│   └── scripts/
└── zsh/                # Z shell
    └── zshrc
```

## Quick Install

```bash
# Clone the repo
git clone https://github.com/ppqwqqq/dotfiles.git "$HOME/projs/dotfiles"

# Run each module's installer
bash "$HOME/projs/dotfiles/alacritty/scripts/install.sh"
bash "$HOME/projs/dotfiles/tmux/scripts/install_plugins.sh"
bash "$HOME/projs/dotfiles/zsh/scripts/install.sh"
```

## Modules

| Module | Description |
|---|---|
| [alacritty](alacritty/) | GPU-accelerated terminal — Tokyo Night theme, FiraCode Nerd Font, 50K scrollback |
| [tmux](tmux/) | Terminal multiplexer — Neovim-aligned keybindings, Catppuccin status bar (top), real-time network speed, 13 plugins |
| [zsh](zsh/) | Shell — Oh My Zsh + powerlevel10k + vi mode + autosuggestions |
