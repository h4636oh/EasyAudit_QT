#!/usr/bin/env bash

# Audit script to verify the status of the 'udf' kernel module.
# The script checks if the 'udf' module is present, if it is deny listed,
# and if it is loaded. The script does not perform any remediation.

# Set the kernel module name we are auditing
l_mod_name="udf"

# Function to perform the module check
f_module_chk() {
    # Gather modprobe configurations for the module
    a_showconfig=()
    while IFS= read -r l_showconfig; do
        a_showconfig+=("$l_showconfig")
    done < <(modprobe --showconfig | grep -Po '\\b'${l_mod_name//-/_}'\\b')

    # Check if the module is currently loaded
    if ! lsmod | grep "$l_mod_name" &> /dev/null; then 
        # Module is not loaded
        a_output+=(" - kernel module: \"$l_mod_name\" is not loaded")
    else
        # Module is loaded
        a_output2+=(" - kernel module: \"$l_mod_name\" is loaded")
    fi

    # Check if the module is set to not load
    if grep -Pq -- '\\binstall\\h+'${l_mod_name//-/_}'\\h+/bin/(true|false)\\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loadable")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loadable")
    fi

    # Check if the module is deny listed
    if grep -Pq -- '\\bblacklist\\h+'${l_mod_name//-/_}'\\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is deny listed")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is not deny listed")
    fi
}

# Check if udf module files exist on the system
l_mod_path="$(readlink -f /lib/modules/**/kernel/fs | sort -u)"
for l_mod_base_directory in $l_mod_path; do
    if [ -d "$l_mod_base_directory/${l_mod_name/-/\\/}" ] && [ -n "$(ls -A $l_mod_base_directory/${l_mod_name/-/\\/})" ]; then
        l_output3="$l_output3\n - \"$l_mod_base_directory\""
    else
        a_output+=(" - kernel module: \"$l_mod_name\" doesn't exist in \"$l_mod_base_directory\"")
    fi
done

# Output results
if [ -n "$l_output3" ]; then
    echo -e "\n\n -- INFO --\n - Module \"$l_mod_name\" exists in:$l_output3\n"
fi

if [ "${#a_output2[@]}" -le 0 ]; then
    echo " - Audit Result:"
    echo " ** PASS **"
    printf '%s\n' "${a_output[@]}"
    exit 0
else
    echo " - Audit Result:"
    echo " ** FAIL **"
    echo " - Reason(s) for audit failure:"
    printf '%s\n' "${a_output2[@]}"
    if [ "${#a_output[@]}" -gt 0 ]; then
        echo "- Correctly set:"
        printf '%s\n' "${a_output[@]}"
    fi
    exit 1
fi

# This script is an audit tool to check the presence and status of the `udf` kernel module according to the given requirements. It verifies if the module is not loaded, not loadable, and deny listed without making any changes to the system.