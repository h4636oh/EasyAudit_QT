#!/bin/bash

# Update package list and install aide and aide-common
sudo apt update
sudo apt install -y aide aide-common

# Configure AIDE
echo "Configuring AIDE as per your environment needs. Please refer to AIDE documentation for detailed configuration options."

# Initialize AIDE
sudo aideinit

# Move the newly created database to the proper location
sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

echo "AIDE installation and initialization complete."

