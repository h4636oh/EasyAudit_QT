#!/bin/bash

# Command to check for non-shadowed passwords
command="awk -F: '(\$2 == \"\" ) { print \$1 \" does not have a password \"}' /etc/shadow"

# Execute the command and capture the output
output=$(eval "$command")

# Check if the output is empty
if [ -z "$output" ]; then
  echo "All users have shadowed passwords."
else
  echo "The following users do not have shadowed passwords:"
  echo "$output"
  exit 1
fi

