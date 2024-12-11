#!/bin/bash
# Script to audit sshd Banner configuration

# Define exit codes
PASS=0
FAIL=1

# Function to check sshd banner configuration
check_sshd_banner() {
    local banner_line
    banner_line=$(sshd -T | grep -Pi -- '^banner\s+/')
    
    if [[ -z "$banner_line" ]]; then
        echo "No sshd Banner is configured."
        return $FAIL
    else
        echo "sshd Banner is configured: $banner_line"
    fi

    # Extract the banner file path
    local banner_file
    banner_file=$(sshd -T | awk '$1 == "banner" {print $2}')

    # Check if the banner file exists and output its content
    if [[ -e "$banner_file" ]]; then
        echo "Banner file exists: $banner_file"
        cat "$banner_file"

        # Check for unwanted strings in the banner file
        local os_name
        os_name=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')

        if grep -Psi -- "(\\\\\\v|\\\\\\r|\\\\\\m|\\\\\\s|\\b${os_name}\\b)" "$banner_file" > /dev/null; then
            echo "Banner file contains unwanted strings."
            return $FAIL
        else
            echo "Banner file content is compliant."
        fi
    else
        echo "Banner file does not exist: $banner_file"
        return $FAIL
    fi

    return $PASS
}

# Execute the audit function
check_sshd_banner
if [[ $? -eq $PASS ]]; then
    echo "PASS: SSHD Banner is configured correctly."
else
    echo "FAIL: SSHD Banner is not configured correctly."
fi
exit $? 