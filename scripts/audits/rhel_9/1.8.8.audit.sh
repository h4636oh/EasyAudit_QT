#!/usr/bin/env bash

# The purpose of the script is to audit the autorun-never setting for GDM.
# It checks whether the "autorun-never" setting is configured correctly.
# The script will exit with code 0 if the check passes and code 1 if it fails.

# Initialize variables
l_pkgoutput=""
l_output=""
l_output2=""

# Determine the system's package manager
if command -v dpkg-query > /dev/null 2>&1; then
    l_pq="dpkg-query -W"
elif command -v rpm > /dev/null 2>&1; then
    l_pq="rpm -q"
else
    echo "Neither dpkg nor rpm package manager found. Audit not applicable."
    exit 1
fi

# Check if GDM is installed
l_pcl="gdm gdm3" # Space-separated list of packages to check
for l_pn in $l_pcl; do
    if $l_pq "$l_pn" > /dev/null 2>&1; then
        l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system - checking configuration"
    fi
done

# Check if any GDM package is found
if [ -z "$l_pkgoutput" ]; then
    echo -e "GNOME Desktop Manager package is not installed on the system.\n- Recommendation is not applicable."
    exit 0
fi

# Print detected packages
echo -e "$l_pkgoutput"

# Check configuration (If applicable)
l_kfile="$(grep -Prils -- '^\h*autorun-never\b' /etc/dconf/db/*.d)"

if [ -f "$l_kfile" ]; then
    l_gpname="$(awk -F/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
fi

# If the profile name exists, continue checks
if [ -n "$l_gpname" ]; then
    l_gpdir="/etc/dconf/db/$l_gpname.d"

    # Check if profile file exists
    if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*; then
        l_output="$l_output\n - dconf database profile file \"$(grep -Pl -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*)\" exists"
    else
        l_output2="$l_output2\n - dconf database profile isn't set"
    fi

    # Check if the dconf database file exists
    if [ -f "/etc/dconf/db/$l_gpname" ]; then
        l_output="$l_output\n - The dconf database \"$l_gpname\" exists"
    else
        l_output2="$l_output2\n - The dconf database \"$l_gpname\" doesn't exist"
    fi

    # Check if the dconf database directory exists
    if [ -d "$l_gpdir" ]; then
        l_output="$l_output\n - The dconf directory \"$l_gpdir\" exists"
    else
        l_output2="$l_output2\n - The dconf directory \"$l_gpdir\" doesn't exist"
    fi

    # Check autorun-never setting
    if grep -Pqrs -- '^\h*autorun-never\h*=\h*true\b' "$l_kfile"; then
        l_output="$l_output\n - \"autorun-never\" is set to true in: \"$l_kfile\""
    else
        l_output2="$l_output2\n - \"autorun-never\" is not set correctly"
    fi
else
    # Settings don't exist. Nothing further to check
    l_output2="$l_output2\n - \"autorun-never\" is not set"
fi

# Report results. If no failures output in l_output2, we pass
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    exit 0
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    exit 1
fi
