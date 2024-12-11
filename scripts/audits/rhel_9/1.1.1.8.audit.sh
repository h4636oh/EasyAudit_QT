#!/usr/bin/env bash

# Script to Audit USB storage module restrictions
# The script checks if the usb-storage kernel module is appropriately restricted
# Exit 0 if audit passes, exit 1 if audit fails

# Module details
MODULE_NAME="usb-storage"
MOD_TYPE="drivers"
MOD_PATH="$(readlink -f /lib/modules/**/kernel/$MOD_TYPE | sort -u)"

audit_usb_storage_module() {
    # Initialize arrays and variables
    unset a_output a_output2
    l_dl="y"
    a_showconfig=()
    
    # Fetch modprobe configuration that involves the usb-storage module
    while IFS= read -r showconfig; do
        a_showconfig+=("$showconfig")
    done < <(modprobe --showconfig | grep -P -- '\b(install|blacklist)\h+'"${MODULE_NAME//-/_}"'\b')

    # Check if the module is currently loaded
    if ! lsmod | grep "$MODULE_NAME" &> /dev/null; then
        a_output+=(" - kernel module: \"$MODULE_NAME\" is not loaded")
    else
        a_output2+=(" - kernel module: \"$MODULE_NAME\" is loaded")
    fi

    # Check if the module is set as not loadable using /bin/true or /bin/false
    if grep -Pq -- '\binstall\h+'"${MODULE_NAME//-/_}"'\h+\/bin\/(true|false)\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$MODULE_NAME\" is not loadable")
    else
        a_output2+=(" - kernel module: \"$MODULE_NAME\" is loadable")
    fi

    # Check if the module is deny listed
    if grep -Pq -- '\bblacklist\h+'"${MODULE_NAME//-/_}"'\b' <<< "${a_showconfig[*]}"; then
        a_output+=(" - kernel module: \"$MODULE_NAME\" is deny listed")
    else
        a_output2+=(" - kernel module: \"$MODULE_NAME\" is not deny listed")
    fi
}

# Main logic to check if usb-storage module exists and run audit
for mod_base_directory in $MOD_PATH; do
    if [ -d "$mod_base_directory/${MODULE_NAME/-/\\/}" ] && [ -n "$(ls -A "$mod_base_directory/${MODULE_NAME/-/\\/}")" ]; then
        l_output3="$l_output3\n - \"$mod_base_directory\""
        [[ "$MODULE_NAME" =~ overlay ]] && MODULE_NAME="${MODULE_NAME::-2}"
        [ "$l_dl" != "y" ] && audit_usb_storage_module
    else
        a_output+=(" - kernel module: \"$MODULE_NAME\" doesn't exist in \"$mod_base_directory\"")
    fi
done

[ -n "$l_output3" ] && echo -e "\n\n -- INFO --\n - module: \"$MODULE_NAME\" exists in:$l_output3"

# Determine audit result
if [ "${#a_output2[@]}" -le 0 ]; then
    printf '%s\n' "" "- Audit Result:" " ** PASS **" "${a_output[@]}"
    exit 0
else
    printf '%s\n' "" "- Audit Result:" " ** FAIL **" " - Reason(s) for audit failure:" "${a_output2[@]}"
    [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "- Correctly set:" "${a_output[@]}"
    exit 1
fi
