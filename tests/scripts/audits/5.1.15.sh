#!/usr/bin/env bash

# Function to check for weak MAC algorithms
check_weak_macs() {
    echo "Checking for weak MAC algorithms in SSH configuration..."
    
    weak_macs_output=$(sshd -T 2>/dev/null | grep -Pi -- \
    'macs\h+([^#\n\r]+,)?(hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64@openssh\.com|hmac-md5-etm@openssh\.com|hmac-md5-96-etm@openssh\.com|hmac-ripemd160-etm@openssh\.com|hmac-sha1-96-etm@openssh\.com|umac-64-etm@openssh\.com|umac-128-etm@openssh\.com)\b')

    if [[ -z "$weak_macs_output" ]]; then
        echo "No weak MAC algorithms found. Configuration is secure."
    else
        echo "Warning: Weak MAC algorithms detected!"
        echo "$weak_macs_output"
        echo "Please review CVE-2023-48795 and ensure the system is patched."
        exit 1
    fi
}

# Run the MAC audit
check_weak_macs