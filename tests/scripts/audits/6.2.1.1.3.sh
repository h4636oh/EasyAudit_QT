#!/bin/bash

# Function to check parameter in a given file
check_parameter() {
    local file=$1
    local parameter=$2
    grep -E "^$parameter" "$file"
}

# Files to inspect
config_files=("/etc/systemd/journald.conf")
config_files+=(/etc/systemd/journald.conf.d/*.conf)

# Parameters to verify
parameters=(
    "SystemMaxUse="
    "SystemKeepFree="
    "RuntimeMaxUse="
    "RuntimeKeepFree="
    "MaxFileSec="
)

echo "Reviewing systemd-journald configuration files for log rotation parameters..."
for file in "${config_files[@]}"; do
    if [ -f "$file" ]; then
        echo "Inspecting $file"
        for parameter in "${parameters[@]}"; do
            check_parameter "$file" "$parameter"
        done
    else
        echo "No configuration files found in $file"
        exit 1
    fi
done

echo "Log rotation parameters check completed."

