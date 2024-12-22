#!/usr/bin/env bash

# Check that the remember argument is not set on the pam_unix.so module
pam_unix_no_remember=$(grep -PH -- '^\h*[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-{password,auth,account,session,session-noninteractive} | grep -Pv -- '\bremember=\d+\b')

if [[ -z "$pam_unix_no_remember" ]]; then
  echo "The remember argument is set on the pam_unix.so module."
else
  echo "No remember argument set on the pam_unix.so module:"
  echo "$pam_unix_no_remember"
fi

