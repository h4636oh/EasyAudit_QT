#```powershell
# PowerShell 7 script to audit the WDigest Authentication setting
# This script checks if the WDigest Authentication using the registry key is set to Disabled

# Define the registry path and value
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest"
$registryName = "UseLogonCredential"

# Attempt to get the registry value
try {
    $useLogonCredential = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop
} catch {
    # If the registry key does not exist, assume it is Disabled (default on Windows 8.1 or newer)
    Write-Host "Registry key not found. It is assumed Disabled as per default for Windows 8.1 or newer."
    exit 0
}

# Check if the value is set to 0 (which means Disabled)
if ($useLogonCredential.$registryName -eq 0) {
    Write-Host "Audit passed: WDigest Authentication is set to Disabled."
    exit 0
} else {
    Write-Host "Audit failed: WDigest Authentication is not set to Disabled."
    Write-Host "Manual action required: Ensure the setting is configured correctly in Group Policy."
    Write-Host "Refer to the following path: Computer Configuration\Policies\Administrative Templates\MS Security Guide\WDigest Authentication"
    exit 1
}
# ```
# 
# This PowerShell script audits the WDigest Authentication setting by checking the specified registry entry to ensure it is set to `Disabled`. It assumes that if the registry key is missing, the system defaults to `Disabled`, which is the case for Windows 8.1 and newer. If the setting is incorrect, it advises the user to manually configure it via Group Policy.
