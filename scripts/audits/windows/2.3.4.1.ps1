#```powershell
# PowerShell 7 script to audit if 'Devices: Prevent users from installing printer drivers' is set to 'Enabled'
# This script checks the registry value to determine the policy setting

# Define the registry path and value name
$regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers'
$regName = 'AddPrinterDrivers'

# Fetch the registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
} catch {
    Write-Host "Error: Unable to read the registry path or the specified value does not exist."
    Write-Host "Please ensure that the path or settings are correctly configured."
    Exit 1
}

# Check if the registry value is set to 1 (Enabled)
if ($regValue.$regName -eq 1) {
    Write-Host "Audit Passed: 'Devices: Prevent users from installing printer drivers' is set to 'Enabled'."
    Exit 0
} else {
    Write-Host "Audit Failed: 'Devices: Prevent users from installing printer drivers' is NOT set to 'Enabled'."
    Write-Host "Please manually set the policy to 'Enabled' in Group Policy."
    Exit 1
}

# ```
