#!/bin/bash

# CPU usage from /proc/stat (locale-independent)
read -r _ user nice system idle iowait irq softirq steal _ _ < /proc/stat
total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle1=$((idle + iowait))

sleep 0.2

read -r _ user nice system idle iowait irq softirq steal _ _ < /proc/stat
total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle2=$((idle + iowait))

delta_total=$((total2 - total1))
delta_idle=$((idle2 - idle1))

if [ "$delta_total" -gt 0 ]; then
    cpu_usage=$(awk -v dt="$delta_total" -v di="$delta_idle" 'BEGIN {printf "%.0f", (dt-di)*100/dt}')
else
    cpu_usage="0"
fi

# CPU temperature
cpu_temp="N/A"
if command -v sensors >/dev/null 2>&1; then
    temp_raw=$(sensors 2>/dev/null | awk '
        /Package id 0:|Tctl:|Tdie:|CPU:|Core 0:/ {
            for (i=1;i<=NF;i++) {
                if ($i ~ /^\+?[0-9]+(\.[0-9]+)?°C$/) {
                    gsub(/^\+/, "", $i)
                    gsub(/°C$/, "", $i)
                    print $i
                    exit
                }
            }
        }
    ')
    if [[ "$temp_raw" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        cpu_temp=$(awk -v t="$temp_raw" 'BEGIN {printf "%.0f", t}')
    fi
fi

if [ "$cpu_temp" = "N/A" ]; then
    for zone in /sys/class/thermal/thermal_zone*; do
        [ -d "$zone" ] || continue
        [ -f "$zone/type" ] || continue
        [ -f "$zone/temp" ] || continue

        ztype=$(tr '[:upper:]' '[:lower:]' < "$zone/type")
        ztemp=$(cat "$zone/temp" 2>/dev/null)

        if [[ "$ztype" =~ (cpu|pkg|x86|k10temp|soc|acpitz|tctl|tdie) ]] && [[ "$ztemp" =~ ^[0-9]+$ ]] && [ "$ztemp" -gt 0 ]; then
            if [ "$ztemp" -gt 1000 ]; then
                cpu_temp=$(awk -v t="$ztemp" 'BEGIN {printf "%.0f", t/1000}')
            else
                cpu_temp="$ztemp"
            fi
            break
        fi
    done
fi

printf "󰍛 %2s%% %3s°" "$cpu_usage" "$cpu_temp"
