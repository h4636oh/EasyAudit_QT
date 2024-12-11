#!/usr/bin/env bash

# This script audits the squashfs kernel module status according to the provided instructions.
# The objective is to ensure that squashfs is not available or is properly deny listed.

# Module and Directory Variables
MODULE_NAME="squashfs"
MODPROBE_DIR="/etc/modprobe.d"

# Audit Functions
audit_squashfs() {
    local module_loaded
    local module_loadable
    local module_deny_listed
    local module_exists_in_system

    # Check if squashfs module is loaded
    if lsmod | grep -q "^${MODULE_NAME}"; then
        module_loaded=true
    else
        module_loaded=false
    fi

    # Check if squashfs module is loadable
    if grep -rq "install ${MODULE_NAME} /bin/\(true\|false\)" $MODPROBE_DIR; then
        module_loadable=true
    else
        module_loadable=false
    fi

    # Check if squashfs module is deny listed
    if grep -rq "blacklist ${MODULE_NAME}" $MODPROBE_DIR; then
        module_deny_listed=true
    else
        module_deny_listed=false
    fi

    # Check if squashfs module exists in the filesystem
    if [ -n "$(find /lib/modules/$(uname -r) -name ${MODULE_NAME}.ko 2>/dev/null)" ]; then
        module_exists_in_system=true
    else
        module_exists_in_system=false
    fi

    # Determine the audit result
    if ! $module_loaded && $module_loadable && $module_deny_listed; then
        echo "** PASS **"
        echo "Audit Result: squashfs module is not loaded, not loadable, and deny listed."
        exit 0
    else
        echo "** FAIL **"
        echo "Audit Result: Issues detected with squashfs module configuration."
        echo "Details:"
        [ $module_loaded = true ] && echo " - The squashfs module is currently loaded."
        [ $module_loadable = false ] && echo " - The squashfs module is not configured as non-loadable."
        [ $module_deny_listed = false ] && echo " - The squashfs module is not deny listed."
        [ $module_exists_in_system = false ] && echo " - The squashfs module does not exist on the filesystem."
        exit 1
    fi
}

# Execute the audit function
audit_squashfs

# This script checks if the `squashfs` kernel module is loaded, loadable, deny listed, and whether it exists on the system. It provides a report and an exit status based on the audit results, ensuring it only assesses and reports without making any changes.