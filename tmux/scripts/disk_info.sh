#!/bin/bash

# Compact fixed-width disk output for /
read -r disk_total_g disk_used_g disk_percent <<< "$(df -BG / --output=size,used,pcent | awk 'NR==2{gsub(/G/,"",$1); gsub(/G/,"",$2); gsub(/%/,"",$3); print $1, $2, $3}')"

if [[ ! "$disk_total_g" =~ ^[0-9]+$ ]]; then disk_total_g=0; fi
if [[ ! "$disk_used_g" =~ ^[0-9]+$ ]]; then disk_used_g=0; fi
if [[ ! "$disk_percent" =~ ^[0-9]+$ ]]; then disk_percent=0; fi

printf "󰋊 %3s/%3s %2s%%" "$disk_used_g" "$disk_total_g" "$disk_percent"
