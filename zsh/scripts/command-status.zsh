#!/usr/bin/env zsh
#
# command-status.zsh
# Shows contextual status banners for known long-running commands (git, docker, etc.)
# and reports execution time when a command takes longer than the threshold.
#
# Source this from ~/.zshrc:  source ~/.zsh/scripts/command-status.zsh

# ----- config ----------------------------------------------------------------
: ${CMD_STATUS_SLOW_THRESHOLD:=5}   # seconds — notify only if command took >= this

# ----- helpers ---------------------------------------------------------------
_cmd_status_timer_start=0

# Detect what a command is "doing" for display
_cmd_status_label() {
    local cmd="$1"
    local label=""

    # -- git ------------------------------------------------------------------
    if [[ "$cmd" =~ 'git[[:space:]]+clone' ]]; then
        local repo="${cmd##*git clone }"
        repo="${repo%% *}"                                      # first arg = URL/path
        repo="${repo##*[:/]}"                                   # strip https://github.com/ etc.
        repo="${repo%.git}"                                     # strip .git suffix
        label="cloning ${repo}..."
    elif [[ "$cmd" =~ 'git[[:space:]]+push' ]]; then
        label="pushing..."
    elif [[ "$cmd" =~ 'git[[:space:]]+pull' ]]; then
        label="pulling..."
    elif [[ "$cmd" =~ 'git[[:space:]]+fetch' ]]; then
        label="fetching..."
    elif [[ "$cmd" =~ 'git[[:space:]]+rebase' ]]; then
        label="rebasing..."
    elif [[ "$cmd" =~ 'git[[:space:]]+merge' ]]; then
        label="merging..."
    elif [[ "$cmd" =~ 'git[[:space:]]+checkout' ]]; then
        local branch="${cmd##*git checkout }"
        branch="${branch%% *}"
        label="checkout ${branch}..."

    # -- package managers -----------------------------------------------------
    elif [[ "$cmd" =~ '(^|[;&|])\s*(npm|pnpm|yarn)\s+install' ]]; then
        label="installing packages..."
    elif [[ "$cmd" =~ '(^|[;&|])\s*(npm|pnpm|yarn)\s+(build|dev|start|test)' ]]; then
        label="running ${match[3]}..."
    elif [[ "$cmd" =~ '(^|[;&|])\s*(cargo|go|make|cmake)\s' ]]; then
        local tool="${match[2]}"
        label="${tool} build..."

    # -- docker ---------------------------------------------------------------
    elif [[ "$cmd" =~ '(^|[;&|])\s*docker\s+build' ]]; then
        label="docker build..."
    elif [[ "$cmd" =~ '(^|[;&|])\s*docker\s+compose\s+up' ]]; then
        label="docker compose up..."
    elif [[ "$cmd" =~ '(^|[;&|])\s*docker\s+(pull|push)' ]]; then
        label="docker ${match[2]}..."

    # -- system ---------------------------------------------------------------
    elif [[ "$cmd" =~ '(^|[;&|])\s*(sudo\s+)?(pacman|yay|paru|apt|dnf)\s' ]]; then
        local pkgmgr="${match[3]}"
        label="${pkgmgr} packages..."

    # -- rsync / scp ----------------------------------------------------------
    elif [[ "$cmd" =~ '(^|[;&|])\s*rsync\s' ]]; then
        label="syncing files..."
    elif [[ "$cmd" =~ '(^|[;&|])\s*scp\s' ]]; then
        label="transferring..."
    fi

    printf '%s' "$label"
}

# ----- hooks -----------------------------------------------------------------

# Called BEFORE each command
_cmd_status_preexec() {
    _cmd_status_timer_start=$SECONDS
    local label
    label=$(_cmd_status_label "$1")

    if [[ -n "$label" ]]; then
        # Print a dimmed contextual header
        printf '\033[2m  ⏳ %s\033[0m\n' "$label"
    fi
}

# Called BEFORE each prompt (after command finishes)
_cmd_status_precmd() {
    local elapsed=0
    if [[ $_cmd_status_timer_start -gt 0 ]]; then
        elapsed=$(( SECONDS - _cmd_status_timer_start ))
        _cmd_status_timer_start=0
    fi

    # Notify when a tracked command took longer than threshold
    if [[ $elapsed -ge $CMD_STATUS_SLOW_THRESHOLD ]]; then
        local mins=$(( elapsed / 60 ))
        local secs=$(( elapsed % 60 ))
        local ts
        if [[ $mins -gt 0 ]]; then
            ts="${mins}m ${secs}s"
        else
            ts="${secs}s"
        fi
        printf '\033[2m  ✓ done (%s)\033[0m\n' "$ts"
    fi
}

# ----- register hooks --------------------------------------------------------
autoload -Uz add-zsh-hook
add-zsh-hook preexec _cmd_status_preexec
add-zsh-hook precmd  _cmd_status_precmd
