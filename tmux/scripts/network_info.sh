#!/bin/bash

PIPE="/tmp/tmux_net_speed"
DAEMON="$HOME/.tmux/scripts/network_speed_daemon.sh"
LOCK="/tmp/tmux_net_daemon.lock"

# Start daemon if not running
if [ ! -f "$LOCK" ] || ! kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null; then
    "$DAEMON" &
    echo $! > "$LOCK"
fi

if [ -f "$PIPE" ]; then
    cat "$PIPE"
else
    printf "󰈀 ---"
fi
