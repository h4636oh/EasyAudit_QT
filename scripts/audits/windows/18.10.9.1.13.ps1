#```powershell
# PowerShell 7 Script to Audit Smart Card Requirement for BitLocker on Fixed Data Drives

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$registryValueName = "FDVEnforceUserCert"

# Attempt to get the registry value
try {
    $enableSmartCard = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "Audit Failed: Unable to retrieve the registry key or it does not exist. Please ensure BitLocker Group Policy is configured."
    exit 1
}

# Check if the registry value matches the required setting
if ($enableSmartCard.$registryValueName -eq 1) {
    Write-Host "Audit Passed: Smart card authentication is required for BitLocker-protected fixed data drives."
    exit 0
} else {
    Write-Host "Audit Failed: Smart card authentication is not set as required. Please check the Group Policy settings."
    Write-Host "Manual Action Required: Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Fixed Data Drives' and set 'Configure use of smart cards on fixed data drives' to 'Enabled: True'."
    exit 1
}
# ```
# 
