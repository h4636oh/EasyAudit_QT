#!/usr/bin/env bash

# Script to audit the cramfs filesystem kernel module

# Initialize variables
l_output3="" 
a_output=() 
a_output2=()
l_mod_name="cramfs" # set module name
l_mod_path="$(readlink -f /lib/modules/**/kernel/fs | sort -u)"

audit_module_cramfs() {
    # Check if the cramfs module is loaded
    if ! lsmod | grep "$l_mod_name" &> /dev/null; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loaded")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loaded")
    fi

    # Get modprobe configuration for cramfs
    a_showconfig=()
    while IFS= read -r l_showconfig; do
        a_showconfig+=("$l_showconfig")
    done < <(modprobe --showconfig | grep -P -- '\\b(install|blacklist)\\h+'"${l_mod_name//-/_}"'\\b')

    # Check for /bin/true or /bin/false install command
    if grep -Pq -- '\\binstall\\h+'"${l_mod_name//-/_}"'\\h+/bin/(true|false)\\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is not loadable")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is loadable")
    fi

    # Check for deny list
    if grep -Pq -- '\\bblacklist\\h+'"${l_mod_name//-/_}"'\\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$l_mod_name\" is deny listed")
    else
        a_output2+=(" - kernel module: \"$l_mod_name\" is not deny listed")
    fi
}

# Check if the module exists in the kernel
for l_mod_base_directory in $l_mod_path; do
    if [ -d "$l_mod_base_directory/${l_mod_name/-/\\/}" ] && [ -n "$(ls -A $l_mod_base_directory/${l_mod_name/-/\\/})" ]; then
        l_output3="$l_output3\\n - \"$l_mod_base_directory\""
        audit_module_cramfs
    else
        a_output+=(" - kernel module: \"$l_mod_name\" doesn't exist in \"$l_mod_base_directory\"")
    fi
done

# Display audit results
if [ -n "$l_output3" ]; then
    echo -e "\n\n -- INFO --\n - module: \"$l_mod_name\" exists in:$l_output3"
fi

if [ "${#a_output2[@]}" -le 0 ]; then
    printf '%s\n' "" "- Audit Result:" " ** PASS **" "${a_output[@]}"
    exit 0
else
    printf '%s\n' "" "- Audit Result:" " ** FAIL **" " - Reason(s) for audit failure:" "${a_output2[@]}"
    [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "- Correctly set:" "${a_output[@]}"
    exit 1
fi