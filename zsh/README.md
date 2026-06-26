# zsh

Z shell configuration — Oh My Zsh + powerlevel10k + vi mode.

## Files

| File | Purpose |
|---|---|
| `zshrc` | Main zsh configuration |
| `plugins/command-status/` | oh-my-zsh plugin — contextual command banners |

## Highlights

- **Framework**: [Oh My Zsh](https://ohmyz.sh/)
- **Theme**: [powerlevel10k](https://github.com/romkatv/powerlevel10k) (config: `~/.p10k.zsh`)
- **Vi mode**: `bindkey -v` — vim-style line editing

### Plugins

| Plugin | Purpose |
|---|---|
| `git` | Git aliases & helpers |
| `z` | Jump to frequent directories |
| `fzf` | Fuzzy finder integration |
| `extract` | Smart archive extraction |
| `sudo` | Prefix with `sudo` via `Esc Esc` |
| `command-not-found` | Package suggestions |
| `history-substring-search` | Substring history matching |
| `dirhistory` | Directory history navigation |
| `colored-man-pages` | Syntax-highlighted man pages |
| `zsh-autosuggestions` | Fish-like autosuggestions |
| `zsh-syntax-highlighting` | Command syntax highlighting |
| `copypath` / `copyfile` | Copy paths/files to clipboard |
| `web-search` | Search from CLI |
| `jsontools` / `encode64` / `urltools` | Data manipulation |
| `battery` / `systemd` / `archlinux` | System integration |
| `command-status` | Contextual command banners (custom) |

### Options

| Option | Effect |
|---|---|
| `AUTO_CD` | `cd` by typing directory name |
| `CORRECT` | Spell-correct commands |
| `NO_BEEP` | Silence terminal bell |
| `SHARE_HISTORY` | Share history across sessions |

### Keybindings

| Key | Action |
|---|---|
| `Esc` / `Ctrl-[` | Normal mode (vi) |
| `Ctrl-R` | Search history backward |
| `Ctrl-S` | Search history forward |
| `Ctrl-X Ctrl-E` | Edit command in `$EDITOR` |
| `↑` / `↓` | History substring search |

### Command Status Banners

Before known heavy commands, a dimmed contextual header is printed. After completion, elapsed time is reported if the command took ≥5 seconds.

```
❯ git clone https://github.com/foo/bar.git
  ⏳ cloning bar...
Cloning into 'bar'...
  ✓ done (12s)

❯ git push origin main
  ⏳ pushing...
Everything up-to-date

❯ npm install
  ⏳ installing packages...
  ✓ done (34s)
```

Supported commands: `git clone/push/pull/fetch/rebase/merge/checkout`, `npm/pnpm/yarn install/build/test`, `docker build/compose up/pull/push`, `cargo/go/make/cmake`, `pacman/yay/paru/apt/dnf`, `rsync`, `scp`.

Threshold controlled by `CMD_STATUS_SLOW_THRESHOLD` env var (default 5s).

### Environment

| Variable | Value |
|---|---|
| `HISTSIZE` / `SAVEHIST` | 50,000 |
| `HISTFILE` | `~/.zsh_history` |
| `FZF_DEFAULT_COMMAND` | `fd` (respects `.gitignore`) |

### Aliases

| Alias | Command |
|---|---|
| `ls` | `lsd` |
| `l` | `lsd -l` |
| `la` | `lsd -la` |
| `tree` | `tree -C` |
| `dot` | Git bare repo for dotfiles |

## Deploy

```bash
# Link zshrc
ln -sf "$HOME/projs/dotfiles/zsh/zshrc" "$HOME/.zshrc"

# Install custom plugins
cp -r "$HOME/projs/dotfiles/zsh/plugins/"* "$ZSH/custom/plugins/"

# Reload
exec zsh
```
