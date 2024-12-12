#!/usr/bin/env bash

# This script audits the GNOME Desktop Manager settings to ensure that screen locks cannot be overridden.
# It checks for proper configuration of the `idle-delay` and `lock-delay` settings in the dconf.

# Check if GNOME Desktop Manager package is installed on the system
pkg_output=""
if command -v dpkg-query > /dev/null 2>&1; then
    pkg_query="dpkg-query -W"
elif command -v rpm > /dev/null 2>&1; then
    pkg_query="rpm -q"
else
    echo "Unsupported package manager."
    exit 1
fi

# Check if GDM or GDM3 is installed
packages="gdm gdm3"
for pkg_name in $packages; do
    if $pkg_query "$pkg_name" > /dev/null 2>&1; then
        pkg_output="${pkg_output}\n - Package: \"$pkg_name\" exists on the system\n"
    fi
done

# If no GNOME packages are found, the audit is not applicable
if [ -z "$pkg_output" ]; then
    echo -e " - GNOME Desktop Manager package is not installed on the system\n - Recommendation is not applicable"
    exit 0
fi

# Check the configuration for idle-delay and lock-delay
output=""
output_fail=""
idle_file=$(grep -Psril '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ || true)
lock_file=$(grep -Psril '^\h*lock-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ || true)

if [ -n "$idle_file" ]; then
    idle_file_dir="/etc/dconf/db/$(awk -F'/' '{split($(NF-1),a,".");print a[1]}' <<< "$idle_file").d"
    if grep -Prilq '/org/gnome/desktop/session/idle-delay\b' "$idle_file_dir"; then
        output="$output\n - \"idle-delay\" is locked in \"$(grep -Pril '/org/gnome/desktop/session/idle-delay\b' "$idle_file_dir")\""
    else
        output_fail="$output_fail\n - \"idle-delay\" is not locked"
    fi
else
    output_fail="$output_fail\n - \"idle-delay\" is not set so it cannot be locked"
fi

if [ -n "$lock_file" ]; then
    lock_file_dir="/etc/dconf/db/$(awk -F'/' '{split($(NF-1),a,".");print a[1]}' <<< "$lock_file").d"
    if grep -Prilq '/org/gnome/desktop/screensaver/lock-delay\b' "$lock_file_dir"; then
        output="$output\n - \"lock-delay\" is locked in \"$(grep -Pril '/org/gnome/desktop/screensaver/lock-delay\b' "$lock_file_dir")\""
    else
        output_fail="$output_fail\n - \"lock-delay\" is not locked"
    fi
else
    output_fail="$output_fail\n - \"lock-delay\" is not set so it cannot be locked"
fi

# Report results
echo -e "$pkg_output"
if [ -z "$output_fail" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n$output\n"
    exit 0
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$output_fail\n"
    [ -n "$output" ] && echo -e "\n- Correctly set:\n$output\n"
    exit 1
fi

# Note: Ensure all descriptive text is properly commented out below.

# This script is designed to audit the GNOME Desktop Manager to ensure that screen locks settings (`idle-delay` and `lock-delay`) cannot be overridden. 
# If these settings are properly locked in their respective configuration files, the script outputs a pass result.
# If not, it outputs a failure and provides reasons for the failure, without making any changes to the system configuration.
