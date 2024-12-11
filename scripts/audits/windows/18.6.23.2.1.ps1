#```powershell
# Ensure PowerShell 7 is running
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "This script requires PowerShell 7 or greater."
    exit 1
}

# Define registry path and value
$registryPath = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
$registryValueName = "AutoConnectAllowedOEM"

# Attempt to retrieve the registry value
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve the registry value. Please ensure the path exists and you have necessary permissions."
    exit 1
}

# Check if the current value is set to Disabled (0)
if ($currentValue.$registryValueName -eq 0) {
    Write-Host "Audit Passed: The setting is correctly set to 'Disabled'."
    exit 0
} else {
    Write-Host "Audit Failed: The setting is not set to 'Disabled'."
    Write-Host "Please manually set 'Allow Windows to automatically connect to suggested open hotspots, to networks shared by contacts, and to hotspots offering paid services' to 'Disabled' via Group Policy."
    exit 1
}
# ```
# 
