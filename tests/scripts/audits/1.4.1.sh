#!/bin/bash

# Extract the username from the set superusers line
USERNAME=$(grep "^set superusers" /boot/grub/grub.cfg | cut -d '"' -f 2)

# Verify set superusers
superusers_output=$(grep "^set superusers" /boot/grub/grub.cfg)
expected_superusers="set superusers=\"$USERNAME\""
if [ "$superusers_output" == "$expected_superusers" ]; then
    echo "Superusers setting is correct."
else
    echo "Superusers setting is incorrect. Found: $superusers_output"
    exit 1
fi

# Verify password_pbkdf2
password_output=$(awk -F. '/^\s*password/ {print $1"."$2"."$3}' /boot/grub/grub.cfg)
expected_password="password_pbkdf2 $USERNAME grub.pbkdf2.sha512"
if [ "$password_output" == "$expected_password" ]; then
    echo "Password setting is correct."
else
    echo "Password setting is incorrect. Found: $password_output"
    exit 1
fi

