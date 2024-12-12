#!/usr/bin/env bash

# This script audits if automatic mounting of removable media is disabled in GNOME

# Determine system's package manager
if command -v dpkg-query > /dev/null 2>&1; then
    l_pq="dpkg-query -W"
elif command -v rpm > /dev/null 2>&1; then
    l_pq="rpm -q"
else
    echo "Unable to determine package manager."
    exit 1
fi

# Check if GDM (GNOME Display Manager) is installed
l_pkgoutput=""
l_pcl="gdm gdm3" # Space-separated list of packages to check

for l_pn in $l_pcl; do
    if $l_pq "$l_pn" > /dev/null 2>&1; then
        l_pkgoutput="${l_pkgoutput}\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
    fi
done

# Check configuration if GNOME is installed
if [ -n "$l_pkgoutput" ]; then
    echo -e "$l_pkgoutput"
    
    l_kfile="$(grep -Prils -- '^\h*automount\b' /etc/dconf/db/*.d 2>/dev/null || true)"
    l_kfile2="$(grep -Prils -- '^\h*automount-open\b' /etc/dconf/db/*.d 2>/dev/null || true)"
    
    if [ -f "$l_kfile" ]; then
        l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile")"
    elif [ -f "$l_kfile2" ]; then
        l_gpname="$(awk -F\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_kfile2")"
    fi
    
    l_output=""
    l_output2=""
    
    if [ -n "$l_gpname" ]; then
        l_gpdir="/etc/dconf/db/$l_gpname.d"
        
        if grep -Pq -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/* 2>/dev/null; then
            l_output="${l_output}\n - dconf database profile file \"$(grep -Pl -- "^\h*system-db:$l_gpname\b" /etc/dconf/profile/*)\" exists"
        else
            l_output2="${l_output2}\n - dconf database profile isn't set"
        fi

        if [ -f "/etc/dconf/db/$l_gpname" ]; then
            l_output="${l_output}\n - The dconf database \"$l_gpname\" exists"
        else
            l_output2="${l_output2}\n - The dconf database \"$l_gpname\" doesn't exist"
        fi
        
        if [ -d "$l_gpdir" ]; then
            l_output="${l_output}\n - The dconf directory \"$l_gpdir\" exists"
        else
            l_output2="${l_output2}\n - The dconf directory \"$l_gpdir\" doesn't exist"
        fi
        
        if ! grep -Pqrs -- '^\h*automount\h*=\h*false\b' "$l_kfile" 2>/dev/null; then
            l_output2="${l_output2}\n - \"automount\" is not set correctly"
        fi
        
        if ! grep -Pqs -- '^\h*automount-open\h*=\h*false\b' "$l_kfile2" 2>/dev/null; then
            l_output2="${l_output2}\n - \"automount-open\" is not set correctly"
        fi
    else
        l_output2="${l_output2}\n - neither \"automount\" or \"automount-open\" is set"
    fi

    # Report results
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
        exit 0
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
        exit 1
    fi
else
    echo -e "\n- GNOME Desktop Manager package is not installed on the system\n- Recommendation is not applicable"
    exit 0
fi
