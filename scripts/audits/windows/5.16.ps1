#```powershell
# PowerShell script to Audit PNRP Machine Name Publication Service Status
# Ensure the script only audits and does not remediate
# The script checks if the PNRP Machine Name Publication Service is set to "Disabled" and exits accordingly.

# Define the registry path and key to check the service status
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\PNRPAutoReg'
$registryKey = 'Start'

# Recommended value for the service to be 'Disabled'
$recommendedValue = 4

# Try to read the current value from the registry
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop
    
    if ($currentValue.$registryKey -eq $recommendedValue) {
        Write-Host "Audit Passed: PNRP Machine Name Publication Service is set to 'Disabled'."
        exit 0
    } else {
        Write-Host "Audit Failed: PNRP Machine Name Publication Service is NOT set to 'Disabled'."
        Write-Host "Follow manual steps to set it as 'Disabled':"
        Write-Host "Go to: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\System Services\\PNRP Machine Name Publication Service"
        exit 1
    }
} catch {
    Write-Host "Error: Unable to retrieve the registry setting. Ensure the path is correct and you have sufficient permissions."
    exit 1
}
# ```
# 
# This script checks the registry to determine if the PNRP Machine Name Publication Service is disabled. If the service is not set to the recommended state (disabled), it prompts the user to manually verify and update the setting through the appropriate Group Policy path. It exits with a status code of 0 for success and 1 for failure or an error.
