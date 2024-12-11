#!/bin/bash

# Script to audit the availability and configuration of the freevxfs kernel module

# Define the kernel module name
KERNEL_MODULE="freevxfs"

# Initialize output arrays
a_output=()
a_output2=()

# Function to check the module configuration
check_module_configuration() {
    # Check if the module is currently loaded
    if ! lsmod | grep -q "$KERNEL_MODULE"; then
        a_output+=(" - kernel module: \"$KERNEL_MODULE\" is not loaded")
    else
        a_output2+=(" - kernel module: \"$KERNEL_MODULE\" is loaded")
    fi

    # Capture modprobe configuration related to the module
    a_showconfig=($(modprobe --showconfig | grep -P "\b(install|blacklist)\h+$KERNEL_MODULE\b"))

    # Check if the module is set to be non-loadable
    if echo "${a_showconfig[@]}" | grep -Pq "\binstall\h+$KERNEL_MODULE\h+/bin/(true|false)\b"; then
        a_output+=(" - kernel module: \"$KERNEL_MODULE\" is not loadable")
    else
        a_output2+=(" - kernel module: \"$KERNEL_MODULE\" is loadable")
    fi

    # Check if the module is deny listed
    if echo "${a_showconfig[@]}" | grep -Pq "\bblacklist\h+$KERNEL_MODULE\b"; then
        a_output+=(" - kernel module: \"$KERNEL_MODULE\" is deny listed")
    else
        a_output2+=(" - kernel module: \"$KERNEL_MODULE\" is not deny listed")
    fi
}

# Function to check if the module exists on the system
check_module_existence() {
    local mod_path=$(readlink -f /lib/modules/**/kernel/fs | sort -u)

    for mod_base_directory in $mod_path; do
        if [ -d "$mod_base_directory/${KERNEL_MODULE}" ] && [ -n "$(ls -A $mod_base_directory/$KERNEL_MODULE)" ]; then
            echo " - \"$mod_base_directory\""
            [ "$l_dl" != "y" ] && check_module_configuration
        else
            a_output+=(" - kernel module: \"$KERNEL_MODULE\" doesn't exist in \"$mod_base_directory\"")
        fi
    done
}

# Main function to conduct the audit
main() {
    check_module_existence

    if [ "${#a_output2[@]}" -le 0 ]; then
        printf '%s\n' "" "- Audit Result:" " ** PASS **" "${a_output[@]}"
        exit 0
    else
        printf '%s\n' "" "- Audit Result:" " ** FAIL **" " - Reason(s) for audit failure:" "${a_output2[@]}"
        [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "- Correctly set:" "${a_output[@]}"
        exit 1
    fi
}

# Run the main function
main

# ### Explanation:
# - This script audits the state of the `freevxfs` kernel module.
# - It checks if the module is loaded, if it is set to non-loadable via `/bin/true` or `/bin/false`, and if it is blacklist in the `/etc/modprobe.d/` directory.
# - The script outputs a pass or fail message based on these checks.
# - The exit status is `0` if the audit passes, meaning all conditions for denying the module's usage are met, and `1` if the audit fails.
# - The audit checks both the presence of module files and the configurations set to manage its loading state.