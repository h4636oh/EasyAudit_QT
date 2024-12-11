#!/usr/bin/env bash

# Run the sshd configuration check for weak ciphers
cipher_output=$(sshd -T 2>/dev/null | grep -Pi '^ciphers\h+"?([^#\n\r]+,)?((3des|blowfish|cast128|aes(128|192|256))-cbc|arcfour(128|256)?|rijndael-cbc@lysator\.liu\.se|chacha20-poly1305@openssh\.com)\b')

# Function to display cipher audit results
display_cipher_audit() {
    if [[ -z "$cipher_output" ]]; then
        echo "No weak ciphers detected in the SSH configuration."
    else
        echo "Weak Ciphers Detected:"
        echo "$cipher_output"
        echo "Please review the list above. Ensure these ciphers are removed from the configuration."
        
        # Check for the specific CVE-related cipher
        if echo "$cipher_output" | grep -q "chacha20-poly1305@openssh.com"; then
            echo "Warning: 'chacha20-poly1305@openssh.com' found."
            echo "Review CVE-2023-48795 and ensure the system is patched."
        fi
        exit 1
    fi
}

# Display the audit results
display_cipher_audit