#!/bin/bash

# Expected values
expected_lock_delay="uint32 5"
expected_idle_delay="uint32 900"

# Get current settings
lock_delay=$(gsettings get org.gnome.desktop.screensaver lock-delay)
idle_delay=$(gsettings get org.gnome.desktop.session idle-delay)

# Verify lock delay
if [ "$lock_delay" == "$expected_lock_delay" ]; then
    echo "Screen lock delay is correctly set to $lock_delay"
else
    echo "Screen lock delay is incorrectly set to $lock_delay. Expected: $expected_lock_delay"
    exit 1
fi

# Verify idle delay
if [ "$idle_delay" == "$expected_idle_delay" ]; then
    echo "Idle delay is correctly set to $idle_delay"
else
    echo "Idle delay is incorrectly set to $idle_delay. Expected: $expected_idle_delay"
    exit 1
fi

