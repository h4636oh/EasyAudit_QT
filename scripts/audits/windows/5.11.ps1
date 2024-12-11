#```powershell
# Script to audit iSCSI Initiator Service settings as per security guidelines

# Function to check the iSCSI Initiator Service startup type in the registry
function Test-iSCSIService {
    $registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\MSiSCSI'
    $serviceStartValue = 4 # Expected value for 'Disabled'
    try {
        $currentValue = Get-ItemProperty -Path $registryPath -Name Start -ErrorAction Stop
        if ($currentValue.Start -eq $serviceStartValue) {
            Write-Output "iSCSI Initiator Service is correctly set to 'Disabled'."
            return $true
        } else {
            Write-Output "iSCSI Initiator Service is NOT set to 'Disabled'. Current value: $($currentValue.Start)"
            return $false
        }
    } catch {
        Write-Output "Error accessing the registry path: $($_.Exception.Message)"
        return $false
    }
}

# Execute the audit function
$serviceCheck = Test-iSCSIService

# Exit with appropriate status code based on the audit result
if ($serviceCheck) {
    exit 0
} else {
    Write-Output "Please review the Group Policy settings manually to ensure the service is 'Disabled'."
    exit 1
}
# ```
