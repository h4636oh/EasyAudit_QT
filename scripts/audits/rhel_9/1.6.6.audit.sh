#!/bin/bash

# This script audits the system-wide crypto policy to ensure that the chacha20-poly1305
# cipher is disabled for SSH, in response to a vulnerability referenced in CVE-2023-48795.

l_output=""
l_output2=""

# Check if the cipher policy is set to CBC
if grep -Piq -- '^\h*cipher\h*=\h*([^#\n\r]+)?-CBC\b' /etc/crypto-policies/state/CURRENT.pol; then
    # Check if the policy is set for `lib` or `open` ssh
    if grep -Piq -- '^\h*cipher@(lib|open)ssh(-server|-client)?\h*=\h*' /etc/crypto-policies/state/CURRENT.pol; then
        # Verify that chacha20-poly1305 is not enabled
        if ! grep -Piq -- '^\h*cipher@(lib|open)ssh(-server|-\client)?\h*=\h*([^#\n\r]+)?\bchacha20-poly1305\b' /etc/crypto-policies/state/CURRENT.pol; then
            l_output="$l_output\n - chacha20-poly1305 is disabled for SSH"
        else
            l_output2="$l_output2\n - chacha20-poly1305 is enabled for SSH"
        fi
    else
        l_output2="$l_output2\n - chacha20-poly1305 is enabled for SSH"
    fi
else
    l_output=" - chacha20-poly1305 is disabled"
fi

# Provide output based on checks
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    exit 0
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    exit 1
fi

### Assumptions:
# - The script checks for the presence of ChaCha20-Poly1305 in the current crypto policy configurations.
# - We assume the configuration file `/etc/crypto-policies/state/CURRENT.pol` exists and is formatted for parsing as indicated.
# - The script uses Perl-compatible regex (`grep -P`) which is generally supported but might not always be available on minimal systems.