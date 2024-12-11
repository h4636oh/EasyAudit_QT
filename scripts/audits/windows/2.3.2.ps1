#```powershell
# PowerShell 7 script to audit if 'Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings' is enabled
# Script adheres to PowerShell 7 syntax and best practices
# Exits with code 0 if audit passes and code 1 if it fails

# Define the registry path and value to check
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
$registryValueName = 'SCENoApplyLegacyAuditPolicy'

# Retrieve the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "Cannot retrieve registry value. It may not exist or there's insufficient permissions."
    exit 1
}

# Evaluate if the registry value meets the audit requirement
if ($registryValue.$registryValueName -eq 1) {
    Write-Host "Audit passed: 'Audit: Force audit policy subcategory settings' is enabled."
    exit 0
} else {
    Write-Host "Audit failed: 'Audit: Force audit policy subcategory settings' is not enabled."
    Write-Host "Please configure the policy manually via Group Policy: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options\\Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings"
    exit 1
}
# ```
