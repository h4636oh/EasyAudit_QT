#!/usr/bin/env bash

# Function to check and print audit results
function audit_gdm_disable_user_list() {
    local l_pkgoutput=""
    local l_pq=""
    local l_gdmfile=""
    local output=""
    local output2=""
    
    # Determine package manager
    if command -v dpkg-query > /dev/null 2>&1; then
        l_pq="dpkg-query -W"
    elif command -v rpm > /dev/null 2>&1; then
        l_pq="rpm -q"
    else
        echo "No supported package manager found. Exiting."
        exit 1
    fi
    
    # List of GNOME Display Manager packages to check
    local l_pcl="gdm gdm3"

    # Check if any GNOME Display Manager packages are installed
    for l_pn in $l_pcl; do
        if $l_pq "$l_pn" > /dev/null 2>&1; then
            l_pkgoutput="${l_pkgoutput}\n - Package: \"$l_pn\" exists on the system\n - Checking configuration"
        fi
    done

    if [ -n "$l_pkgoutput" ]; then
        # Check if the disable-user-list is enabled
        l_gdmfile=$(grep -Pril '^\h*disable-user-list\h*=\h*true\b' /etc/dconf/db)

        if [ -n "$l_gdmfile" ]; then
            output="${output}\n - The \"disable-user-list\" option is enabled in \"$l_gdmfile\""
            l_gdmprofile=$(awk -F/ '{split($(NF-1),a,"."); print a[1]}' <<< "$l_gdmfile")
            
            if grep -Pq "^\h*system-db:$l_gdmprofile" /etc/dconf/profile/"$l_gdmprofile"; then
                output="$output\n - The \"$l_gdmprofile\" profile exists in /etc/dconf/profile"
            else
                output2="$output2\n - The \"$l_gdmprofile\" profile doesn't exist in /etc/dconf/profile"
            fi

            if [ -f "/etc/dconf/db/$l_gdmprofile" ]; then
                output="$output\n - The \"$l_gdmprofile\" profile exists in the dconf database"
            else
                output2="$output2\n - The \"$l_gdmprofile\" profile doesn't exist in the dconf database"
            fi
        else
            output2="$output2\n - The \"disable-user-list\" option is not enabled"
        fi

        if [ -z "$output2" ]; then
            echo -e "$l_pkgoutput\n- Audit Result:\n *** PASS: ***\n$output\n"
            exit 0
        else
            echo -e "$l_pkgoutput\n- Audit Result:\n *** FAIL: ***\n$output2\n"
            [ -n "$output" ] && echo -e "$output\n"
            exit 1
        fi
    else
        echo -e "\n\n - GNOME Desktop Manager isn't installed\n - Recommendation is Not Applicable\n- Audit Result:\n *** PASS ***\n"
        exit 0
    fi
}

# Run the audit function
audit_gdm_disable_user_list
