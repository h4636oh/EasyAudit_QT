#!/usr/bin/env bash

# Script to audit if the hfs kernel module is correctly disabled

# Variables
l_mod_name="hfs" # Module name
l_mod_type="fs" # Module type
l_mod_path="$(readlink -f /lib/modules/**/kernel/$l_mod_type | sort -u)" # Path to module
audit_pass=true # Flag to check audit result

# Function to check module
f_module_chk() {
    a_showconfig=() # Array to store modprobe configuration
    while IFS= read -r l_showconfig; do
        a_showconfig+=("$l_showconfig")
    done < <(modprobe --showconfig | grep -P -- '\\b(install|blacklist)\\h+'"${l_mod_name//-/_}"'\\b')

    # Check if module is loaded
    if lsmod | grep "$l_mod_name" &> /dev/null; then
        echo " - kernel module: \"$l_mod_name\" is loaded"
        audit_pass=false
    else
        echo " - kernel module: \"$l_mod_name\" is not loaded"
    fi

    # Check if module is not loadable
    if grep -Pq -- '\\binstall\\h+'"${l_mod_name//-/_}"'\\h+\\/bin\\/(true|false)\\b' <<< "${a_showconfig[*]}"; then
        echo " - kernel module: \"$l_mod_name\" is not loadable"
    else
        echo " - kernel module: \"$l_mod_name\" is loadable"
        audit_pass=false
    fi

    # Check if module is deny listed
    if grep -Pq -- '\\bblacklist\\h+'"${l_mod_name//-/_}"'\\b' <<< "${a_showconfig[*]}"; then
        echo " - kernel module: \"$l_mod_name\" is deny listed"
    else
        echo " - kernel module: \"$l_mod_name\" is not deny listed"
        audit_pass=false
    fi
}

# Iterate over potential module paths
for l_mod_base_directory in $l_mod_path; do
    if [ -d "$l_mod_base_directory/${l_mod_name/-/\\/}" ] && [ -n "$(ls -A $l_mod_base_directory/${l_mod_name/-/\\/})" ]; then
        echo " - Module \"$l_mod_name\" exists in: \"$l_mod_base_directory\""
        f_module_chk
    else
        echo " - kernel module: \"$l_mod_name\" doesn’t exist in \"$l_mod_base_directory\""
        # If module doesn't exist, assume this part of audit passes
    fi
done

# Final audit result
if $audit_pass; then
    echo "** PASS **"
    exit 0
else
    echo "** FAIL **"
    exit 1
fi