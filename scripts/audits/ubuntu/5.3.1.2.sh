#!/usr/bin/env bash

# Define the package to check
package="libpam-modules"
required_version="1.5.2-6"

echo "Auditing the installation and version of ${package}..."

# Check the installation status and version of the package
output=$(dpkg-query -s "${package}" | grep -P -- '^(Status|Version)\b')

if [[ $? -eq 0 ]]; then
    echo "Audit result for ${package}:"
    echo "${output}"

    # Check if the package is installed correctly
    if echo "${output}" | grep -q "Status: install ok installed"; then
        echo "The package '${package}' is installed correctly."
    else
        echo "WARNING: The package '${package}' is not installed correctly!"
        exit 1
    fi

    # Extract and compare the version
    version=$(echo "${output}" | grep "Version:" | awk '{print $2}')
    echo "Installed Version: ${version}"

    # Compare versions
    if dpkg --compare-versions "${version}" ge "${required_version}"; then
        echo "The installed version of '${package}' (${version}) meets the required version (${required_version})."
    else
        echo "WARNING: The installed version of '${package}' (${version}) is older than the required version (${required_version})."
        exit 1
    fi
else
    echo "ERROR: Failed to retrieve information for '${package}'. Is it installed?"
    exit 1
fi

echo "Audit completed successfully."
