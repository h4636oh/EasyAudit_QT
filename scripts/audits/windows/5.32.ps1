#```powershell
# PowerShell 7 script to audit the 'Web Management Service (WMSvc)' status

# Define registry path and key for Web Management Service
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\WMSvc'
$registryKey = 'Start'

# Define the expected value for the registry key
$expectedValue = 4

# Function to check if the 'Web Management Service' is correctly configured
function Test-WebManagementService {
    # Check if the registry path exists
    if (Test-Path $registryPath) {
        # Get the current Start value of the service
        $value = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue

        # Check if the value of Start is the expected value (Disabled)
        if ($value -ne $null -and $value.$registryKey -eq $expectedValue) {
            Write-Output "Audit Passed: 'Web Management Service' is Disabled."
            return $true
        }
        else {
            Write-Output "Audit Failed: 'Web Management Service' is Enabled. Please ensure the service is Disabled or Not Installed."
            return $false
        }
    }
    else {
        Write-Output "Audit Passed: 'Web Management Service' is Not Installed."
        return $true
    }
}

# Run the audit function
if (Test-WebManagementService) {
    exit 0
} else {
    exit 1
}
# ```
# 
# This script checks if the "Web Management Service (WMSvc)" is either disabled or not installed by verifying the registry value. If the service is configured correctly, the script will exit with a status of 0, indicating the audit passed. Otherwise, it will exit with a status of 1, indicating the audit failed.
