#!/bin/bash

cache_file="/tmp/tmux_gpu_info_${UID}.cache"
cache_ttl=5
now=$(date +%s)

if [ -f "$cache_file" ]; then
    cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null)
    if [ -n "$cache_mtime" ] && [ $((now - cache_mtime)) -lt "$cache_ttl" ]; then
        cat "$cache_file"
        exit 0
    fi
fi

if ! command -v nvidia-smi >/dev/null 2>&1; then
    output=$(printf "󰢮 %-7s %2s%% %2s°" "N/A" "--" "--")
    printf "%s" "$output" | tee "$cache_file" >/dev/null
    printf "%s" "$output"
    exit 0
fi

gpu_info=$(nvidia-smi --query-gpu=name,utilization.gpu,temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -1)

if [ -n "$gpu_info" ]; then
    gpu_name_raw=$(echo "$gpu_info" | cut -d',' -f1 | sed 's/^ *//')
    gpu_util=$(echo "$gpu_info" | cut -d',' -f2 | sed 's/^ *//')
    gpu_temp=$(echo "$gpu_info" | cut -d',' -f3 | sed 's/^ *//')

    model_num=$(echo "$gpu_name_raw" | grep -oE '[0-9]{3,4}' | head -1)
    if echo "$gpu_name_raw" | grep -qi 'RTX' && [ -n "$model_num" ]; then
        gpu_name_short="RTX${model_num}"
    elif echo "$gpu_name_raw" | grep -qi 'GTX' && [ -n "$model_num" ]; then
        gpu_name_short="GTX${model_num}"
    elif [ -n "$model_num" ]; then
        gpu_name_short="GPU${model_num}"
    else
        gpu_name_short=$(echo "$gpu_name_raw" | awk '{print $1}')
    fi

    output=$(printf "󰢮 %-7s %2s%% %2s°" "$gpu_name_short" "$gpu_util" "$gpu_temp")
else
    output=$(printf "󰢮 %-7s %2s%% %2s°" "N/A" "--" "--")
fi

printf "%s" "$output" | tee "$cache_file" >/dev/null
printf "%s" "$output"
