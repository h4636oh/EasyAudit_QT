#```powershell
# Script to audit the policy setting for requiring the use of smart cards on BitLocker-protected removable data drives
# Verify the registry setting: HKLM\SOFTWARE\Policies\Microsoft\FVE:RDVEnforceUserCert

# Define the registry path and value name
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$valueName = 'RDVEnforceUserCert'

# Attempt to retrieve the registry value
try {
    $regValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Registry setting not found. Please check if BitLocker policies are being applied correctly."
    exit 1
}

# Check if the value is set to 1 (indicating smart card requirement is enabled)
if ($regValue.$valueName -eq 1) {
    Write-Host "Audit Passed: The policy is correctly set to require smart card use."
    exit 0
} else {
    Write-Host "Audit Failed: The policy is NOT set to require smart card use."
    Write-Host "Manual Action Required: Ensure the group policy setting is set to 'Enabled: True'."
    exit 1
}

# ```
