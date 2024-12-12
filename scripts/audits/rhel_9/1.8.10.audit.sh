#!/bin/bash

# Title: 1.8.10 Ensure XDMCP is not enabled (Automated)
# Description: Audit script to ensure X Display Manager Control Protocol (XDMCP) is not enabled
# Profiles: Level 1 - Server, Level 1 - Workstation

# CIS Controls:
# 4.8 Uninstall or Disable Unnecessary Services on Enterprise Assets and Software
# 9.2 Ensure Only Approved Ports, Protocols and Services Are Running

# Audit Command
grep_output=$(grep -Eis '^\s*Enable\s*=\s*true' /etc/gdm/custom.conf)

# Examine the output of the grep command
if [ -z "$grep_output" ]; then
    # If no output is returned, the audit passes
    echo "Audit passed: XDMCP is not enabled."
    exit 0
else
    # If output is returned, the audit fails
    echo "Audit failed: XDMCP is enabled. Please manually edit /etc/gdm/custom.conf and remove the line 'Enable=true'."
    exit 1
fi
