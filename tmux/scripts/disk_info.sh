#!/bin/bash

# Compact disk output — percentage only
read -r disk_percent <<< "$(df -BG / --output=pcent | awk 'NR==2{gsub(/%/,"",$1); print $1}')"

if [[ ! "$disk_percent" =~ ^[0-9]+$ ]]; then disk_percent="N/A"; fi

printf "󰋊 %s%%" "$disk_percent"
