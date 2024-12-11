#!/bin/bash

# Parameters for log rotation
parameters=(
    "SystemMaxUse="
    "SystemKeepFree="
    "RuntimeMaxUse="
    "RuntimeKeepFree="
    "MaxFileSec="
)

# File to be edited
config_files=("/etc/systemd/journald.conf")
config_files+=(/etc/systemd/journald.conf.d/*.conf)

# Function to update or add parameters in the [Journal] section
update_config() {
    local file=$1
    echo "Updating $file..."
    sudo sed -i '/

\[Journal\]

/!b;:a;n;/^[^#]/b;p;ba' $file
    for param in "${parameters[@]}"; do
        if grep -q "^$param" "$file"; then
            echo "Parameter $param already exists in $file."
        else
            echo "$param" | sudo tee -a "$file"
        fi
    done
}

# Update each config file
for file in "${config_files[@]}"; do
    if [ -f "$file" ]; then
        update_config "$file"
    else
        echo "File $file does not exist."
    fi
done

echo "Log rotation parameters have been updated."

