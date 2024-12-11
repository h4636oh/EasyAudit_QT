#```powershell
# Script to audit the policy setting for "Turn off cloud optimized content"
# This script checks the registry key to ensure the policy is set to "Enabled" as recommended.

# Define the registry path and the expected value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'
$registryName = 'DisableCloudOptimizedContent'
$expectedValue = 1

# Attempt to retrieve the current registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop
} catch {
    Write-Output "Audit failed: Registry path or setting does not exist. Manual configuration required."
    exit 1
}

# Check if the registry value matches the expected value
if ($registryValue.$registryName -eq $expectedValue) {
    Write-Output "Audit passed: 'Turn off cloud optimized content' is set to 'Enabled'."
    exit 0
} else {
    Write-Output "Audit failed: 'Turn off cloud optimized content' is not set to 'Enabled'. Manual action is required."
    Write-Output "Please ensure the Group Policy is set correctly via the following path:"
    Write-Output "Computer Configuration\Policies\Administrative Templates\Windows Components\Cloud Content\Turn off cloud optimized content"
    exit 1
}
# ```
