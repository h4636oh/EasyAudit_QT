#!/usr/bin/env bash

# Ensure the /etc/systemd/journald.conf.d/ directory exists
[ ! -d /etc/systemd/journald.conf.d/ ] && mkdir /etc/systemd/journald.conf.d/

# Check if the parameter exists in the configuration file, if not, add it
if grep -Psq -- '^\h*

\[Journal\]

' /etc/systemd/journald.conf.d/60-journald.conf; then
    printf '%s\n' "Compress=yes" >> /etc/systemd/journald.conf.d/60-journald.conf
else
    printf '%s\n' "[Journal]" "Compress=yes" >> /etc/systemd/journald.conf.d/60-journald.conf
fi

# Reload or restart the systemd-journald service to apply the changes
systemctl reload-or-restart systemd-journald

echo "Compress has been set to yes, and systemd-journald service has been reloaded or restarted."

