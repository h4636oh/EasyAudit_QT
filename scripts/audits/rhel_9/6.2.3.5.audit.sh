#!/bin/bash

# Audit Script for rsyslog Configuration

# Check if rsyslog is installed
if ! command -v rsyslogd &> /dev/null; then
  echo "Fail: rsyslog is not installed."
  exit 1
fi

# Check if rsyslog service is running
if ! systemctl is-active --quiet rsyslog; then
  echo "Fail: rsyslog service is not running."
  exit 1
fi

# Verify /etc/rsyslog.conf
if [ ! -f /etc/rsyslog.conf ]; then
  echo "Fail: /etc/rsyslog.conf is missing."
  exit 1
fi

# Verify /etc/rsyslog.d/*.conf
if ! compgen -G "/etc/rsyslog.d/*.conf" > /dev/null; then
  echo "Warning: No additional configuration files found in /etc/rsyslog.d."
fi

# Check /var/log/maillog
if [ ! -f /var/log/maillog ]; then
  echo "Fail: /var/log/maillog is missing."
  exit 1
fi

# If all checks pass
echo "Pass: All rsyslog configurations are correctly set."
exit 0
