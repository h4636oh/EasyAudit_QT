#!/usr/bin/env bash

# Check if 'umask' is set correctly in root's profile files
grep -Psi -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' /root/.bash_profile /root/.bashrc

# Output the result
if [ $? -eq 0 ]; then
  echo "FAIL: 'umask' is set in /root/.bash_profile or /root/.bashrc"
else
  echo "PASS: 'umask' is not set in /root/.bash_profile or /root/.bashrc, which is correct."
fi
