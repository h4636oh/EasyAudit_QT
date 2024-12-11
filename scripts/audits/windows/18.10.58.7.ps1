#```powershell
# This script audits the configuration of the "Allow search highlights" policy setting
# It checks the registry value to ensure it is set to Disabled, which is represented by a value of 0

# Define the registry path and the expected value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
$registryValueName = "EnableDynamicContentInWSB"
$expectedValue = 0

# Try to get the current registry value
try {
    # Retrieve the current value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

    # Check if the current value matches the expected value
    if ($currentValue.$registryValueName -eq $expectedValue) {
        Write-Output "Audit Passed: The 'Allow search highlights' policy setting is correctly set to Disabled."
        exit 0
    }
    else {
        Write-Output "Audit Failed: The 'Allow search highlights' policy setting is not set to Disabled."
        exit 1
    }
}
catch {
    # If an error occurs (e.g., the registry key or value does not exist), prompt the user for manual verification
    Write-Warning "Unable to retrieve or find the value for 'EnableDynamicContentInWSB'. Please verify manually."
    exit 1
}

# Note that modifications to the system are not performed by this script; it is solely for auditing purposes.
# ```
