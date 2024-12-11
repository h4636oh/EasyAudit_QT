#!/usr/bin/env bash

# Script to audit if Cipher Block Chaining (CBC) is disabled for SSH
# Adheres to the system's crypto policies on applicable servers and workstations.

# Function to audit CBC settings in the crypto policy
audit_cbc_disabled_for_ssh() {
    local output=""
    local output2=""

    # Check if CBC is mentioned in the CURRENT crypto policy
    if grep -Piq -- '^\h*cipher\h*=\h*([^#\n\r]+)?-CBC\b' /etc/crypto-policies/state/CURRENT.pol; then
        if grep -Piq -- '^\h*cipher@(lib|open)ssh(-server|-client)?\h*=\h*' /etc/crypto-policies/state/CURRENT.pol; then
            if ! grep -Piq -- '^\h*cipher@(lib|open)ssh(-server|-client)?\h*=\h*([^#\n\r]+)?-CBC\b' /etc/crypto-policies/state/CURRENT.pol; then
                output="$output\n - Cipher Block Chaining (CBC) is disabled for SSH"
            else
                output2="$output2\n - Cipher Block Chaining (CBC) is enabled for SSH"
            fi
        else
            output2="$output2\n - Cipher Block Chaining (CBC) is enabled for SSH"
        fi
    else
        output=" - Cipher Block Chaining (CBC) is disabled"
    fi

    # Display the audit result
    if [ -z "$output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$output\n"
        exit 0
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$output2\n"
        [ -n "$output" ] && echo -e "\n- Correctly set:\n$output\n"
        exit 1
    fi
}

# Invoke the audit function
audit_cbc_disabled_for_ssh

