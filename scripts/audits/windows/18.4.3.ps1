#```powershell
# Script Title: Audit Script for SMB v1 Server Configuration
# This script audits the SMB v1 server configuration to ensure it is disabled as per recommended security guidelines.
# The script checks the registry value and reports an audit pass or fail status.

# Define the registry path and the required value
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'
$registryValueName = 'SMB1'
$expectedValue = 0

# Function to check the registry setting
function Test-SMBv1Configuration {
    try {
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
        if ($currentValue.$registryValueName -eq $expectedValue) {
            # Audit passed
            Write-Output "Audit Passed: SMBv1 is disabled."
            return $true
        } else {
            # Audit failed
            Write-Warning "Audit Failed: SMBv1 is not disabled."
        }
    } catch {
        Write-Warning "Audit Failed: Could not retrieve registry value for SMBv1. Error: $_"
    }
    return $false
}

# Execute the audit check
if (Test-SMBv1Configuration) {
    # Exit with code 0 for audit pass
    exit 0
} else {
    # Exit with code 1 for audit fail
    exit 1
}

# If manual verification is required:
Write-Host "Please verify via Group Policy that the following path is configured:"
Write-Host "Computer Configuration\\Policies\\Administrative Templates\\MS Security Guide\\Configure SMB v1 server"
Write-Host "The setting should be set to 'Disabled'."
# ```
