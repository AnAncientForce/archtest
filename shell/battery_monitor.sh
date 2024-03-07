#!/bin/bash
# @AnAncientForce >> HP

# This script is responsible for monitoring the battery life, and warning at a critical level.

last_percent=0

while true; do
  battery_status=$(acpi -b | awk '{print $3}' | sed 's/,//')
  battery_percentage=$(acpi -b | grep -o "[0-9]\{1,3\}%" | tr -d '%')

  echo "Battery: $battery_percentage"

  if [[ "$battery_status" == "Discharging" && "$battery_percentage" -lt 20 && "$last_percent" != "$battery_percentage" ]]; then
    last_percent=$battery_percentage
    dunstify "Low Battery" "($battery_percentage%)" -u critical
    sox "~/sounds/xp/Windows XP Battery Critical.wav" -d
  fi

  if [[ "$battery_status" == "Charging" && "$battery_percentage" -gt 95 && "$last_percent" != "$battery_percentage" ]]; then
    last_percent=$battery_percentage
    dunstify "Almost Charged" "($battery_percentage%)" -u normal
    sox "~/sounds/xp/notify.wav" -d
  fi

  sleep 60
done
