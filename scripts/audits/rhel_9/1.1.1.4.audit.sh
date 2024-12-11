#!/usr/bin/env bash

# Audit Script for Ensuring the hfsplus Kernel Module is not Available

# Module and paths
MODULE_NAME="hfsplus"
MODULE_TYPE="fs"
MODULE_PATH="$(readlink -f /lib/modules/**/kernel/$MODULE_TYPE | sort -u)"

# Arrays to collect outputs
a_output=()
a_output2=()

# Function to verify module status
audit_module() {
    # Get modprobe configuration for the module
    a_showconfig=()
    while IFS= read -r line; do
        a_showconfig+=("$line")
    done < <(modprobe --showconfig | grep -P -- '\\b(install|blacklist)\\h+'"${MODULE_NAME//-/_}"'\\b')

    # Check if the module is loaded
    if ! lsmod | grep -q "$MODULE_NAME"; then
        a_output+=(" - kernel module: \"$MODULE_NAME\" is not loaded")
    else
        a_output2+=(" - kernel module: \"$MODULE_NAME\" is loaded")
    fi

    # Check if the module is set to not load
    if grep -Pq -- '\\binstall\\h+'"${MODULE_NAME//-/_}"'\\h+/bin/(true|false)\\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$MODULE_NAME\" is not loadable")
    else
        a_output2+=(" - kernel module: \"$MODULE_NAME\" is loadable")
    fi

    # Check if the module is deny listed
    if grep -Pq -- '\\bblacklist\\h+'"${MODULE_NAME//-/_}"'\\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$MODULE_NAME\" is deny listed")
    else
        a_output2+=(" - kernel module: \"$MODULE_NAME\" is not deny listed")
    fi
}

# Perform audit
found_module=false
for mod_base_directory in $MODULE_PATH; do
    if [ -d "$mod_base_directory/${MODULE_NAME/-/\\/}" ] && [ -n "$(ls -A $mod_base_directory/${MODULE_NAME/-/\\/})" ]; then
        found_module=true
        audit_module
    else
        a_output+=(" - kernel module: \"$MODULE_NAME\" doesn't exist in \"$mod_base_directory\"")
    fi
done

# Report audit results
if $found_module; then
    if [ "${#a_output2[@]}" -le 0 ]; then
        echo -e "\n- Audit Result:\n  ** PASS **"
        printf '%s\n' "${a_output[@]}"
        exit 0
    else
        echo -e "\n- Audit Result:\n  ** FAIL **"
        echo " - Reason(s) for audit failure:"
        printf '%s\n' "${a_output2[@]}"
        if [ "${#a_output[@]}" -gt 0 ]; then
            echo " - Correctly set:"
            printf '%s\n' "${a_output[@]}"
        fi
        exit 1
    fi
else
    # If the module is not found, no further configuration is necessary
    echo -e "\n- Audit Result:\n  ** PASS **"
    echo " - Module \"$MODULE_NAME\" is not available."
    exit 0
fi

# This script audits the presence and configuration of the `hfsplus` kernel module to ensure it is not loaded, not loadable, and deny listed where applicable. It provides pass/fail feedback based on the audit conditions.