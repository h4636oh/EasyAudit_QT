#!/usr/bin/env bash

# Function to audit the DCCP kernel module
audit_dccp_module() {
    local mod_name="dccp"  # set module name
    local mod_type="net"   # set module type
    local mod_path  # variable to hold the module path
    local a_output=()  # array to hold successful checks
    local a_output2=()  # array to hold failed checks

    # Resolve the path for the kernel module
    mod_path=$(readlink -f /lib/modules/**/kernel/$mod_type | sort -u)

    # Function to check the module status
    f_module_chk() {
        local a_showconfig=()  # Array to hold modprobe output
        local l_showconfig
        while IFS= read -r l_showconfig; do
            a_showconfig+=("$l_showconfig")
        done < <(modprobe --showconfig | grep -P -- '\b(install|blacklist)\h+'"${mod_name//-/_}"'\b')

        # Check if the module is currently loaded
        if ! lsmod | grep "$mod_name" &> /dev/null; then
            a_output+=(" - kernel module: \"$mod_name\" is not loaded")
        else
            a_output2+=(" - kernel module: \"$mod_name\" is loaded")
        fi

        # Check if the module is set to not load
        if grep -Pq -- '\binstall\h+'"${mod_name//-/_}"'\h+\/bin\/(true|false)\b' <<<"${a_showconfig[*]}"; then
            a_output+=(" - kernel module: \"$mod_name\" is not loadable")
        else
            a_output2+=(" - kernel module: \"$mod_name\" is loadable")
        fi

        # Check if the module is deny listed
        if grep -Pq -- '\bblacklist\h+'"${mod_name//-/_}"'\b' <<<"${a_showconfig[*]}"; then
            a_output+=(" - kernel module: \"$mod_name\" is deny listed")
        else
            a_output2+=(" - kernel module: \"$mod_name\" is not deny listed")
        fi
    }

    # Check if the module exists on the system
    for l_mod_base_directory in $mod_path; do
        if [ -d "$l_mod_base_directory/${mod_name/-/\//}" ] && [ -n "$(ls -A $l_mod_base_directory/${mod_name/-/\//})" ]; then
            echo -e "\n\n -- INFO --\n - module: \"$mod_name\" exists in:\n - \"$l_mod_base_directory\""
            f_module_chk
        else
            a_output+=(" - kernel module: \"$mod_name\" doesn't exist in \"$l_mod_base_directory\"")
        fi
    done

    # Determine audit result based on collected information
    if [ "${#a_output2[@]}" -le 0 ]; then
        printf '%s\n' "" "- Audit Result:" " ** PASS **" "${a_output[@]}"
        exit 0
    else
        printf '%s\n' "" "- Audit Result:" " ** FAIL **" " - Reason(s) for audit failure:" "${a_output2[@]}"
        [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "- Correctly set:" "${a_output[@]}"
        exit 1
    fi
}

# Run the audit function
audit_dccp_module

# This script audits the Datagram Congestion Control Protocol (DCCP) kernel module to ensure it is not available on the system. It checks if the module is loaded, loadable, or deny listed and outputs the results based on these checks. The script exits with a status of 0 if all conditions for a successful audit are met, otherwise it exits with a status of 1.