#!/bin/bash

PIPE="/tmp/tmux_net_speed"
DAEMON="$HOME/.tmux/scripts/network_speed_daemon.sh"

# Start daemon in background if not running
if ! pgrep -f "[n]etwork_speed_daemon" >/dev/null 2>&1; then
    "$DAEMON" &>/dev/null &
    disown
fi

cat "$PIPE" 2>/dev/null || printf "󰈀 ---"
