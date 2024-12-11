#!/usr/bin/env bash

# Audit script to ensure the rds kernel module is not available, according to security guidelines.
# This script checks configuration files and the current kernel state, but does not modify them.

# Setting up variables
l_mod_name="rds" # Kernel module name
l_mod_type="net" # Kernel module type
l_mod_path="$(readlink -f /lib/modules/**/kernel/$l_mod_type | sort -u)" # Path for modules
a_output=() # Array to store audit results for passing checks
a_output2=() # Array to store audit failure reasons

# Function to check the status of the rds module
f_module_chk() {
    a_showconfig=() # Array to collect showconfig results

    # Collect the modprobe configuration related to the rds module
    while IFS= read -r l_showconfig; do
        a_showconfig+=("$l_showconfig")
    done < <(modprobe --showconfig | grep -P -- '\\b(install|blacklist)\\h+'"${l_mod_name//-/_}"'\\b')

    # Check if the rds module is currently loaded
    if ! lsmod | grep "$l_mod_name" &> /dev/null; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loaded")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loaded")
    fi

    # Check if the rds module is set not to load
    if grep -Pq -- '\\binstall\\h+'"${l_mod_name//-/_}"'\\h+/bin/(true|false)\\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loadable")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loadable")
    fi

    # Check if the rds module is deny listed
    if grep -Pq -- '\\bblacklist\\h+'"${l_mod_name//-/_}"'\\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is deny listed")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is not deny listed")
    fi
}

# Main logic to check if the module directory contains the rds module
for l_mod_base_directory in $l_mod_path; do
    if [ -d "$l_mod_base_directory/${l_mod_name/-/\\/}" ] && [ -n "$(ls -A $l_mod_base_directory/${l_mod_name/-/\\/})" ]; then
        f_module_chk
    else
        a_output+=(" - kernel module: \"$l_mod_name\" doesn't exist in \"$l_mod_base_directory\"")
    fi
done

# Output the results and determine script exit code
if [ "${#a_output2[@]}" -le 0 ]; then
    echo -e "\n\n -- INFO --"
    echo -e " - Audit Result: ** PASS **"
    printf '%s\n' "${a_output[@]}"
    exit 0
else
    echo -e "\n\n -- INFO --"
    echo -e " - Audit Result: ** FAIL **"
    echo -e " - Reason(s) for audit failure:"
    printf '%s\n' "${a_output2[@]}"
    echo -e "- Correctly set:"
    [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "${a_output[@]}"
    exit 1
fi

# The script is an audit-only script to verify the state of the `rds` kernel module in line with described security best practices. It checks whether the module is loaded, not loadable, and deny-listed without making any changes to the system configuration.