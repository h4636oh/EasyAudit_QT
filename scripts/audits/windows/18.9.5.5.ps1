#```powershell
# Ensure the script is running with privileges to access HKLM registry
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script requires administrator privileges. Please run as an administrator."
    exit 1
}

# Define registry path and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$registryValueName = "LsaCfgFlags"
$expectedValue = 1

# Check if the registry path exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path is not found: $registryPath. Please ensure Credential Guard policy is properly configured."
    exit 1
}

# Try to get the actual value from the registry
try {
    $actualValue = Get-ItemPropertyValue -Path $registryPath -Name $registryValueName -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve the registry value. Ensure the policy is applied."
    exit 1
}

# Check if the value matches the expected value
if ($actualValue -eq $expectedValue) {
    Write-Host "Audit Passed: The setting for 'Turn On Virtualization Based Security: Credential Guard Configuration' is correctly set to 'Enabled with UEFI lock'."
    exit 0
} else {
    Write-Host "Audit Failed: The setting for 'Turn On Virtualization Based Security: Credential Guard Configuration' is NOT set to 'Enabled with UEFI lock'."
    Write-Host "Please manually check the Group Policy settings or use the path: Computer Configuration\Policies\Administrative Templates\System\Device Guard\Turn On Virtualization Based Security."
    exit 1
}
# ```
