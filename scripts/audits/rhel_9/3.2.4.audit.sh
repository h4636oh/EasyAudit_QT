#!/usr/bin/env bash

# Audit script to ensure the SCTP kernel module is not available
# Exit 0 if audit passes, exit 1 if audit fails.

MOD_NAME="sctp"
MOD_TYPE="net"
OUTPUT_PASS=""
OUTPUT_FAIL=""

# Function to check if the module is configured correctly
function audit_module {
    # Check if the module is loaded
    if lsmod | grep "$MOD_NAME" &> /dev/null; then
        OUTPUT_FAIL+=" - kernel module: \"$MOD_NAME\" is loaded\n"
    else
        OUTPUT_PASS+=" - kernel module: \"$MOD_NAME\" is not loaded\n"
    fi

    # Check if the module is not loadable (/bin/true or /bin/false in config)
    if modprobe --showconfig | grep -Pq -- '\binstall\s+'"$MOD_NAME"'\s+/bin/(true|false)\b'; then
        OUTPUT_PASS+=" - kernel module: \"$MOD_NAME\" is not loadable\n"
    else
        OUTPUT_FAIL+=" - kernel module: \"$MOD_NAME\" is loadable\n"
    fi

    # Check if the module is deny listed
    if modprobe --showconfig | grep -Pq -- '\bblacklist\s+'"$MOD_NAME"'\b'; then
        OUTPUT_PASS+=" - kernel module: \"$MOD_NAME\" is deny listed\n"
    else
        OUTPUT_FAIL+=" - kernel module: \"$MOD_NAME\" is not deny listed\n"
    fi

    # Determine audit result
    if [ -n "$OUTPUT_FAIL" ]; then
        echo -e "\n- Audit Result: ** FAIL **\n - Reason(s) for audit failure:\n${OUTPUT_FAIL}"
        [ -n "$OUTPUT_PASS" ] && echo -e "- Correctly set:\n${OUTPUT_PASS}"
        exit 1
    else
        echo -e "\n- Audit Result: ** PASS **\n${OUTPUT_PASS}"
        exit 0
    fi
}

# Main execution
# Check if there's any available kernel module related to SCTP in the file system
MOD_PATH="$(readlink -f /lib/modules/**/kernel/$MOD_TYPE | sort -u)"
MOD_EXISTS=false

for BASE_DIR in $MOD_PATH; do
    if [ -d "$BASE_DIR/${MOD_NAME/-/\\/}" ] && [ -n "$(ls -A "$BASE_DIR/${MOD_NAME/-/\\/}")" ]; then
        MOD_EXISTS=true
        echo -e "\n-- INFO --\n - module: \"$MOD_NAME\" exists in $BASE_DIR"
        break
    fi
done

if [ "$MOD_EXISTS" = true ]; then
    audit_module
else
    echo -e "\n- No further configuration is necessary as the module is not available on the system."
    exit 0
fi

# This script checks if the SCTP kernel module is loaded, configured as not loadable, and deny listed. If any condition is not met, it reports a failure and exits with status 1. If all checks are passed, it reports success and exits with status 0. It also checks if the SCTP kernel module exists in the system before performing these audits.