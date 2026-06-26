#!/bin/bash

# Compact fixed-width network output
interface=$(ip route | awk '/default/ {print $5; exit}')

if [ -n "$interface" ]; then
    ip_addr=$(ip -4 addr show "$interface" | awk '/inet / {print $2}' | cut -d'/' -f1 | head -1)
    [ -n "$ip_addr" ] || ip_addr="N/A"

    ip_short=$(echo "$ip_addr" | cut -c1-12)

    if [[ "$interface" =~ ^wl ]]; then
        printf "󰖩 %-12s" "$ip_short"
    else
        printf "󰈀 %-12s" "$ip_short"
    fi
else
    printf "󰈂 %-12s" "offline"
fi
