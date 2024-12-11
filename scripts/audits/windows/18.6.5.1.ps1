#```powershell
# This script audits the 'Enable Font Providers' setting to ensure it is set to 'Disabled'
# as recommended for a Level 2 (L2) - High Security/Sensitive Data Environment.

# Registry path and value for auditing
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$registryName = "EnableFontProviders"
$desiredValue = 0

# Check if the registry key exists
if (Test-Path $registryPath) {
    # Get the current value of the registry setting
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $registryName

    # Compare the current value with the desired value
    if ($null -ne $currentValue -and $currentValue -eq $desiredValue) {
        Write-Output "Audit Passed: 'Enable Font Providers' is set to 'Disabled'."
        exit 0
    } else {
        Write-Output "Audit Failed: 'Enable Font Providers' is not set to 'Disabled'. Please check the Group Policy setting."
        exit 1
    }
} else {
    Write-Output "Audit Failed: Registry path does not exist. Please ensure the Group Policy is configured correctly."
    exit 1
}
# ```
