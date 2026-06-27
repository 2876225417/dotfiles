#!/bin/bash

# Compact RAM output — percentage only
if [ -f /proc/meminfo ]; then
    mem_total_kb=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
    mem_available_kb=$(awk '/MemAvailable/ {print $2}' /proc/meminfo)
    mem_used_kb=$((mem_total_kb - mem_available_kb))

    if [ "$mem_total_kb" -gt 0 ]; then
        mem_percent=$(awk -v used="$mem_used_kb" -v total="$mem_total_kb" 'BEGIN {printf "%.0f", used*100/total}')
    else
        mem_percent=0
    fi

    mem_used_gb=$(awk -v kb="$mem_used_kb" 'BEGIN {printf "%.1f", kb/1024/1024}')

    printf "󰘚 %sG • %s%%" "$mem_used_gb" "$mem_percent"
else
    printf "󰘚 N/A"
fi
