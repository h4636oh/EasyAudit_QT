#!/bin/bash

# Command to verify umask settings for the root user
output=$(grep -Psi -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' /root/.bash_profile /root/.bashrc)

# Check if the output is empty
if [[ -z "$output" ]]; then
    echo "The root user's umask is set correctly to enforce permissions of 750 for directories and 640 for files, or more restrictive."
else
    echo "The root user's umask settings need to be reviewed:"
    echo "$output"
    exit 1
fi

