#!/bin/bash

# Load average (1m)
load_avg=$(awk '{print $1}' /proc/loadavg)
cpu_cores=$(nproc)

if [[ ! "$load_avg" =~ ^[0-9]+\.?[0-9]*$ ]]; then
    load_avg="0.0"
fi

if [ "$cpu_cores" -gt 0 ]; then
    load_percent=$(awk -v la="$load_avg" -v cores="$cpu_cores" 'BEGIN {printf "%.0f", (la/cores)*100}')
else
    load_percent=0
fi

icon="󰑮"
printf "%s %s (%s%%)" "$icon" "$load_avg" "$load_percent"
