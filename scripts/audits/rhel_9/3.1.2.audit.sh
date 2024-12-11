#!/bin/bash

# Description: Audit script to ensure wireless interfaces are disabled.
# Profile Applicability: Level 1 - Server
# This script checks if there are any active wireless interfaces on the system.

check_wireless_modules() {
    local l_output l_output2

    # Function to check the status of a given module
    module_chk() {
        local l_mname="$1"
        # Check how module will be loaded
        local l_loadable
        l_loadable=$(modprobe -n -v "$l_mname")
        if grep -Pq -- '^\h*install /bin/(true|false)' <<< "$l_loadable"; then
            l_output="${l_output}\n - module: \"$l_mname\" is not loadable:\n\"$l_loadable\""
        else
            l_output2="${l_output2}\n - module: \"$l_mname\" is loadable:\n\"$l_loadable\""
        fi

        # Check if the module is currently loaded
        if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
            l_output="${l_output}\n - module: \"$l_mname\" is not loaded"
        else
            l_output2="${l_output2}\n - module: \"$l_mname\" is loaded"
        fi

        # Check if the module is deny listed
        if modprobe --showconfig | grep -Pq -- "^\h*blacklist\h+$l_mname\b"; then
            l_output="${l_output}\n - module: \"$l_mname\" is deny listed in:\n\"$(grep -Pl -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*)\""
        else
            l_output2="${l_output2}\n - module: \"$l_mname\" is not deny listed"
        fi
    }

    # Search for wireless directories and manage each found module
    if [ -n "$(find /sys/class/net/* -type d -name wireless)" ]; then
        local l_dname
        l_dname=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs dirname); do basename "$(readlink -f "$driverdir"/device/driver/module)"; done | sort -u)
        for l_mname in $l_dname; do
            module_chk "$l_mname"
        done
    fi

    # Report results. If no failures are output in l_output2, audit passes.
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **"
        [ -z "$l_output" ] && echo -e "\n - System has no wireless NICs installed" || echo -e "\n$l_output\n"
        exit 0
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
        exit 1
    fi
}

# Execute the function to check wireless modules
check_wireless_modules
