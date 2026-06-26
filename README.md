# dotfiles

Personal configuration files, organized by application.

```
dotfiles/
├── alacritty/          # Alacritty terminal emulator
│   ├── alacritty.toml
│   └── themes/
├── tmux/               # tmux multiplexer
│   ├── tmux.conf
│   └── scripts/
└── zsh/                # Z shell
    └── zshrc
```

## Quick Install

```bash
# Clone and checkout
git clone --bare https://github.com/ppqwqqq/dotfiles.git $HOME/.dotfiles
alias dot='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dot checkout

# Deploy configs to home directory
ln -sf "$HOME/projs/dotfiles/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
ln -sf "$HOME/projs/dotfiles/tmux/tmux.conf"           "$HOME/.tmux.conf"
ln -sf "$HOME/projs/dotfiles/zsh/zshrc"                "$HOME/.zshrc"

# Install tmux plugins
bash "$HOME/projs/dotfiles/tmux/scripts/install_plugins.sh"
```

## Modules

| Module | Description |
|---|---|
| [alacritty](alacritty/) | GPU-accelerated terminal — Tokyo Night theme, FiraCode Nerd Font, 50K scrollback |
| [tmux](tmux/) | Terminal multiplexer — Neovim-aligned keybindings, Catppuccin status bar, 12 plugins |
| [zsh](zsh/) | Shell — Oh My Zsh + powerlevel10k + vi mode + autosuggestions |
