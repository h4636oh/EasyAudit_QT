# #!/usr/bin/env bash

# echo "Auditing sudo configuration for custom log file..."

# # Check for 'Defaults logfile' in /etc/sudoers and included files
# logfile_output=$(grep -rPsi '^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(\"|\')?\H+(\"|\')?(,\h*\H+\h*)*\h*(#.*)?$' /etc/sudoers*)

# # Define the expected log file path
# expected_logfile='Defaults logfile="/var/log/sudo.log"'

# # Verify if 'Defaults logfile' is correctly set
# if echo "$logfile_output" | grep -q "$expected_logfile"; then
#     echo "Audit passed: Custom sudo log file is configured as expected."
# else
#     echo "Audit failed: Custom sudo log file is not set correctly."
#     echo "Current output:"
#     echo "$logfile_output"
#     exit 1
# fi
#!/usr/bin/env bash

# Check if a custom log file is configured in sudoers files
grep -rPsi "^\h*Defaults\h+.*logfile\h*=\h*['\"]?\S+['\"]?\h*(#.*)?$" /etc/sudoers* > /dev/null
if [ $? -eq 0 ]; then
    echo "PASS: Custom logfile for sudo is configured."
else
    echo "FAIL: Custom logfile for sudo is not configured."
    exit 1
fi

# Verify the log file path is set correctly
grep -rPsi '^\h*Defaults\h+logfile\s*=\s*"/var/log/sudo.log"' /etc/sudoers* > /dev/null
if [ $? -eq 0 ]; then
    echo "PASS: Sudo logfile is correctly set to /var/log/sudo.log."
else
    echo "FAIL: Sudo logfile is not set to /var/log/sudo.log."
    exit 1
fi