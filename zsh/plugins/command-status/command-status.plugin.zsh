# --------------------------------------------------------------------------- #
# command-status — oh-my-zsh plugin                                           #
#                                                                             #
# Shows contextual status banners for known long-running commands and reports #
# execution time when a command exceeds the threshold.                        #
#                                                                             #
# Integrates with powerlevel10k colour scheme (Catppuccin Mocha).             #
#                                                                             #
# Add "command-status" to the plugins array in ~/.zshrc.                      #
# --------------------------------------------------------------------------- #

# ----- config ----------------------------------------------------------------
: ${CMD_STATUS_SLOW_THRESHOLD:=5}   # seconds — notify only if command took >= this

# ----- p10k-compatible Catppuccin Mocha colours ------------------------------
# True-color; falls back gracefully on terminals without support.
typeset -A _cs_c
_cs_c=(
    icon   $'\e[38;2;203;166;247m'   # mauve
    label  $'\e[38;2;147;153;178m'   # overlay2 (dim)
    done_  $'\e[38;2;166;227;161m'   # green
    time_  $'\e[38;2;249;226;175m'   # yellow
    reset  $'\e[0m'
)

# ----- internal state --------------------------------------------------------
typeset -g _cmd_status_timer_start=0
typeset -g _cmd_status_last_label=""

# Detect what a command is "doing" for display
_cmd_status_label() {
    setopt localoptions extendedglob
    local cmd="$1" label=""

    # -- git
    if   [[ "$cmd" =~ 'git[[:space:]]+clone'       ]]; then label="cloning"
    elif [[ "$cmd" =~ 'git[[:space:]]+push'        ]]; then label="pushing"
    elif [[ "$cmd" =~ 'git[[:space:]]+pull'        ]]; then label="pulling"
    elif [[ "$cmd" =~ 'git[[:space:]]+fetch'       ]]; then label="fetching"
    elif [[ "$cmd" =~ 'git[[:space:]]+rebase'      ]]; then label="rebasing"
    elif [[ "$cmd" =~ 'git[[:space:]]+merge'       ]]; then label="merging"
    elif [[ "$cmd" =~ 'git[[:space:]]+checkout'    ]]; then label="checkout"
    elif [[ "$cmd" =~ 'git[[:space:]]+stash'       ]]; then label="stashing"

    # -- package managers
    elif [[ "$cmd" =~ '(^|[;&|])\s*(npm|pnpm|yarn)\s+install'                        ]]; then label="installing packages"
    elif [[ "$cmd" =~ '(^|[;&|])\s*(npm|pnpm|yarn)\s+(build|dev|start|test|run)'      ]]; then label="${match[3]}…"
    elif [[ "$cmd" =~ '(^|[;&|])\s*(pip|pip3)\s+install'                              ]]; then label="pip install"
    elif [[ "$cmd" =~ '(^|[;&|])\s*(cargo|go|make|cmake|ninja)\s'                     ]]; then label="${match[2]} build"

    # -- docker / containers
    elif [[ "$cmd" =~ '(^|[;&|])\s*docker\s+build'   ]]; then label="docker build"
    elif [[ "$cmd" =~ '(^|[;&|])\s*docker\s+compose' ]]; then label="docker compose"
    elif [[ "$cmd" =~ '(^|[;&|])\s*docker\s+(pull|push|run)' ]]; then label="docker ${match[2]}"

    # -- system package managers
    elif [[ "$cmd" =~ '(^|[;&|])\s*(sudo\s+)?(pacman|yay|paru|apt|dnf|zypper)\s' ]]; then label="${match[3]}"

    # -- file transfer
    elif [[ "$cmd" =~ '(^|[;&|])\s*rsync\s' ]]; then label="syncing"
    elif [[ "$cmd" =~ '(^|[;&|])\s*scp\s'   ]]; then label="transferring"

    # -- archive
    elif [[ "$cmd" =~ '(^|[;&|])\s*(tar|zip|unzip|7z)\s' ]]; then label="${match[2]}…"

    # -- network tools
    elif [[ "$cmd" =~ '(^|[;&|])\s*(curl|wget)\s' ]]; then label="downloading"
    fi

    printf '%s' "$label"
}

# ----- hooks -----------------------------------------------------------------

# Called BEFORE each command executes
_command_status_preexec() {
    _cmd_status_timer_start=$SECONDS
    local label
    label=$(_cmd_status_label "$1")
    _cmd_status_last_label="$label"

    if [[ -n "$label" ]]; then
        printf '%s  ⏳ %s%s\n' "${_cs_c[icon]}" "$label" "${_cs_c[reset]}"
    fi
}

# Called BEFORE each prompt (after command finishes)
_command_status_precmd() {
    local elapsed=0
    if [[ $_cmd_status_timer_start -gt 0 ]]; then
        elapsed=$(( SECONDS - _cmd_status_timer_start ))
        _cmd_status_timer_start=0
    fi

    # Notify when a tracked command took >= threshold
    if [[ -n "$_cmd_status_last_label" && $elapsed -ge $CMD_STATUS_SLOW_THRESHOLD ]]; then
        local mins=$(( elapsed / 60 ))
        local secs=$(( elapsed % 60 ))
        local ts
        if [[ $mins -gt 0 ]]; then
            ts="${mins}m ${secs}s"
        else
            ts="${secs}s"
        fi
        printf '%s  ✓ %s %s(%s)%s\n' \
            "${_cs_c[done_]}" "$_cmd_status_last_label" "${_cs_c[time_]}" "$ts" "${_cs_c[reset]}"
    fi
    _cmd_status_last_label=""
}

# ----- register --------------------------------------------------------------
autoload -Uz add-zsh-hook
add-zsh-hook preexec _command_status_preexec
add-zsh-hook precmd  _command_status_precmd
