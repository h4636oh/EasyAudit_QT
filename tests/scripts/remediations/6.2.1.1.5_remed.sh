#!/usr/bin/env bash

# Create the directory if it does not exist
[ ! -d /etc/systemd/journald.conf.d/ ] && mkdir /etc/systemd/journald.conf.d/

# Check if the parameter exists in the configuration file, if not, add it
if grep -Psq -- '^\h*

\[Journal\]

' /etc/systemd/journald.conf.d/60-journald.conf; then
    printf '%s\n' "Storage=persistent" >> /etc/systemd/journald.conf.d/60-journald.conf
else
    printf '%s\n' "[Journal]" "Storage=persistent" >> /etc/systemd/journald.conf.d/60-journald.conf
fi

# Reload or restart the systemd-journald service to apply the changes
systemctl reload-or-restart systemd-journald

echo "Storage has been set to persistent, and systemd-journald service has been reloaded or restarted."

