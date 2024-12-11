#```powershell
# Script to audit 'Configure use of smart cards on fixed data drives' policy setting for BitLocker
# The audited registry value should be set to 1 (Enabled)
# Exits with 0 if compliant, and exits with 1 if non-compliant

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$registryValueName = "FDVAllowUserCert"
$desiredValue = 1

# Attempt to read the registry value
try {
    $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
    
    # Check if the actual value matches the desired value
    if ($actualValue.$registryValueName -eq $desiredValue) {
        Write-Host "Audit Passed: 'Configure use of smart cards on fixed data drives' is set to 'Enabled'."
        exit 0
    } else {
        Write-Host "Audit Failed: 'Configure use of smart cards on fixed data drives' is NOT set to 'Enabled'."
        Write-Host "Navigate to Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> BitLocker Drive Encryption -> Fixed Data Drives and enable 'Configure use of smart cards on fixed data drives'."
        exit 1
    }
} catch {
    Write-Host "Audit Failed: Unable to read the registry value. Please check if the registry path and value name are correct."
    exit 1
}
# ```
# 
