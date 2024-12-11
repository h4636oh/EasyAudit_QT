#```powershell
# PowerShell 7 Script to Audit SSDP Discovery Service Status
# This script audits the status of the SSDP Discovery service to ensure it is set to Disabled.
# It does not make any changes to the system configuration.

# Define the registry path for the SSDP Discovery service.
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SSDPSRV"
$registryValue = "Start"

try {
    # Attempt to get the Start value from the registry
    $serviceStatus = Get-ItemProperty -Path $registryPath -Name $registryValue -ErrorAction Stop

    # Check if the service is set to Disabled (4)
    if ($serviceStatus.$registryValue -eq 4) {
        Write-Output "Audit Passed: SSDP Discovery service is disabled."
        exit 0
    }
    else {
        Write-Output "Audit Failed: SSDP Discovery service is not set to Disabled. Please follow the remediation steps to disable it manually."
        exit 1
    }
}
catch {
    Write-Output "Audit Failed: Unable to retrieve SSDP Discovery service configuration. Check registry access permissions."
    exit 1
}
# ```
