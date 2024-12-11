#```powershell
# Script to audit the policy setting for 'Microsoft network server: Server SPN target name validation level'
# Expects the registry value at "HKLM\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters:SMBServerNameHardeningLevel" to be 1

# Define the registry path and value name
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters"
$valueName = "SMBServerNameHardeningLevel"

# Get the current value from the registry
try {
    $value = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Error: Unable to retrieve the registry setting. Please ensure the path and value names are correct."
    Exit 1
}

# Check the value and determine if it matches the recommended state
if ($value.$valueName -eq 1) {
    Write-Host "Audit Passed: The SMB server SPN target name validation level is correctly set."
    Exit 0
} else {
    Write-Host "Audit Failed: The SMB server SPN target name validation level is not set as recommended."
    Write-Host "Manual Action Required: Please configure the setting to 'Accept if provided by client' or 'Required from client'."
    Exit 1
}
# ```
