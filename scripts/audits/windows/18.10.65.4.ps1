#```powershell
# This script audits the registry setting for "Turn off the offer to update to the latest version of Windows"
# It checks if the setting is configured as 'Enabled' by matching the registry value to 1.

# Define the registry path and the expected value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore'
$registryName = 'DisableOSUpgrade'
$expectedValue = 1

# Function to audit the registry setting
Function Audit-StoreUpgradeSetting {
    try {
        # Check if the registry key and value exist
        if (Test-Path $registryPath) {
            $actualValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue
            
            # Check if the registry value matches the expected value
            if ($null -ne $actualValue -and $actualValue.$registryName -eq $expectedValue) {
                Write-Output "Audit Passed: The setting 'Turn off the offer to update to the latest version of Windows' is Enabled."
                exit 0
            } else {
                Write-Output "Audit Failed: The setting 'Turn off the offer to update to the latest version of Windows' is not Enabled. Please set it manually."
                exit 1
            }
        } else {
            Write-Output "Audit Failed: The registry path $registryPath does not exist. Please configure the setting manually."
            exit 1
        }
    } catch {
        Write-Output "Audit Failed: An error occurred while trying to read the registry. Error: $_"
        exit 1
    }
}

# Run the audit function
Audit-StoreUpgradeSetting
# ```
# 
# This script checks whether the registry setting related to disabling OS upgrades via the Microsoft Store is set to 'Enabled'. If the setting is correct, the script exits with code 0. If the setting is incorrect or cannot be verified, it instructs the user to manually review and configure the setting before exiting with code 1.
