#```powershell
# Define the registry path and value name for auditing
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\InputPersonalization"
$valueName = "AllowInputPersonalization"

# Retrieve the current registry value
$registryValue = Get-ItemProperty -Path $registryPath -ErrorAction SilentlyContinue

# Check if the registry value exists and is set to Disabled (0)
if ($null -eq $registryValue) {
    Write-Host "Policy not configured. Please check manually."
    exit 1
} elseif ($registryValue.$valueName -eq 0) {
    Write-Host "Audit passed: 'Allow users to enable online speech recognition services' is set to 'Disabled'."
    exit 0
} else {
    Write-Host "Audit failed: 'Allow users to enable online speech recognition services' is not set to 'Disabled'."
    Write-Host "Please manually set the Group Policy as prescribed in the remediation section."
    exit 1
}
# ```
# 
# This PowerShell script checks if the registry setting for the input personalization policy is properly configured. It prompts action if the configuration doesn't match the recommended settings.
