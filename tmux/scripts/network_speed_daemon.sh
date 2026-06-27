#!/bin/bash

# Background network speed monitor — updates cache file every 0.1s
# Started by network_info.sh if not already running

format_speed() {
    local bytes=$1
    if (( bytes >= 1073741824 )); then
        printf "%4.1fG" "$(echo "scale=1; $bytes/1073741824" | bc)"
    elif (( bytes >= 1048576 )); then
        printf "%4.1fM" "$(echo "scale=1; $bytes/1048576" | bc)"
    elif (( bytes >= 1024 )); then
        printf "%4.1fK" "$(echo "scale=1; $bytes/1024" | bc)"
    else
        printf "%4dB" "$bytes"
    fi
}

interface=$(ip route | awk '/default/ {print $5; exit}')
[ -z "$interface" ] && exit 1

ifs="󰈀"; [[ "$interface" =~ ^wl ]] && ifs="󰖩"
cache="/tmp/tmux_net_speed"

while true; do
    rx=$(cat /sys/class/net/"$interface"/statistics/rx_bytes 2>/dev/null)
    tx=$(cat /sys/class/net/"$interface"/statistics/tx_bytes 2>/dev/null)
    now=$(date +%s%N)

    if [ -n "$prev_rx" ] && [ -n "$rx" ]; then
        dt=$(( (now - prev_ts) / 1000000000 ))
        dt_ns=$(( now - prev_ts ))
        if [ "$dt_ns" -gt 0 ]; then
            rx_speed=$(( (rx - prev_rx) * 1000000000 / dt_ns ))
            tx_speed=$(( (tx - prev_tx) * 1000000000 / dt_ns ))
            printf "%s ↓%s ↑%s" "$ifs" "$(format_speed $rx_speed)" "$(format_speed $tx_speed)" > "$cache"
        fi
    fi

    prev_rx=$rx
    prev_tx=$tx
    prev_ts=$now
    sleep 0.1
done
