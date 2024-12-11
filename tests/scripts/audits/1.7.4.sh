#!/bin/bash

# Check lock-delay setting
lock_delay=$(gsettings get org.gnome.desktop.screensaver lock-delay | cut -d' ' -f2)

if [[ "$lock_delay" -gt 5 ]]; then
  echo "FAIL : Warning - lock-delay is set to $lock_delay seconds. It should be 5 seconds or less."
else
  echo "PASS : lock-delay is set to $lock_delay seconds. This is within the recommended limit."
fi

# Check idle-delay setting
idle_delay=$(gsettings get org.gnome.desktop.session idle-delay | cut -d' ' -f2)

if [[ "$idle_delay" -gt 900 ]]; then
  echo "FAIL : Warning - idle-delay is set to $idle_delay seconds. It should be 900 seconds (15 minutes) or less."
elif [[ "$idle_delay" -eq 0 ]]; then
  echo "Warning - idle-delay is disabled. This is not recommended."
  exit 1
else
  echo "idle-delay is set to $idle_delay seconds. This is within the recommended limit."
fi
