#```powershell
# Script to audit the policy setting for 'Network access: Do not allow storage of passwords and credentials for network authentication'
# This script checks the registry value and prompts for manual verification if necessary.
# Exit code 0 indicates success (audit passed); exit code 1 indicates failure (audit failed).

# Define the registry path and value name
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$ValueName = "DisableDomainCreds"

# Attempt to get the registry value
try {
    $registryValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction Stop
    $isEnabled = $registryValue.$ValueName -eq 1
} catch {
    Write-Error "Failed to retrieve registry value for $ValueName. Ensure the key exists: $RegistryPath"
    exit 1
}

# Check if the value is 'Enabled' (i.e., equals to 1)
if ($isEnabled) {
    Write-Host "Audit Passed: 'Network access: Do not allow storage of passwords and credentials for network authentication' is set to 'Enabled'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Network access: Do not allow storage of passwords and credentials for network authentication' is NOT set to 'Enabled'."
    Write-Host "Please verify manually in Group Policy under: Computer Configuration -> Policies -> Windows Settings -> Security Settings -> Local Policies -> Security Options"
    exit 1
}
# ```
