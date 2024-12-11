#!/usr/bin/env bash

# Description: Audit the TIPC kernel module to ensure it's not available/utilized or pre-compiled into the kernel.
# The script will check for module existence, ensure it is deny listed, not loaded, and not loadable.
# Exits 0 if all conditions for a successful audit are met, otherwise exits 1.

l_mod_name="tipc"  # Set the module name
l_mod_type="net"   # Set the module type
l_mod_path="$(readlink -f /lib/modules/**/kernel/$l_mod_type | sort -u)" # Get module path

# Function to check and report state of the TIPC module
f_module_chk() {
    a_showconfig=() # Create array to collect modprobe output

    # Read modprobe configurations to check for blacklist and install lines
    while IFS= read -r l_showconfig; do
        a_showconfig+=("$l_showconfig")
    done < <(modprobe --showconfig | grep -P -- '\b(install|blacklist)\h+'"${l_mod_name//-/_}"'\b')

    # Check module loading state and configurations
    a_output=()
    a_output2=()

    if ! lsmod | grep "$l_mod_name" &> /dev/null; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loaded")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loaded")
    fi

    if grep -Pq -- '\binstall\h+'"${l_mod_name//-/_}"'\h+\/bin\/(true|false)\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loadable")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loadable")
    fi

    if grep -Pq -- '\bblacklist\h+'"${l_mod_name//-/_}"'\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is deny listed")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is not deny listed")
    fi
}

# Check if the module exists on the system in any of the paths identified
for l_mod_base_directory in $l_mod_path; do
    if [ -d "$l_mod_base_directory/${l_mod_name/-/\_/}" ] && [ -n "$(ls -A $l_mod_base_directory/${l_mod_name/-/\_/})" ]; then
        f_module_chk
    else
        a_output+=(" - kernel module: \"$l_mod_name\" doesn't exist in \"$l_mod_base_directory\"")
    fi
done

# Report audit results
if [ "${#a_output2[@]}" -le 0 ]; then
    printf '%s\n' "" "- Audit Result:" " ** PASS **" "${a_output[@]}"
    exit 0
else
    printf '%s\n' "" "- Audit Result:" " ** FAIL **" " - Reason(s) for audit failure:" "${a_output2[@]}"
    [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "- Correctly set:" "${a_output[@]}"
    exit 1
fi
