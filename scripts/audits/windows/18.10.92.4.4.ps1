#```powershell
# PowerShell 7 Script to Audit Registry Setting for Optional Updates Policy

# Define the registry path and the value name to check
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$valueName = "AllowOptionalContent"
$expectedValue = 0

# Check if the registry path exists
if (Test-Path $registryPath) {
    # Get the current value of the AllowOptionalContent registry key
    $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue
    if ($null -ne $currentValue) {
        # Compare the current value to the expected value
        if ($currentValue.$valueName -eq $expectedValue) {
            Write-Host "Audit Passed: 'Enable optional updates' is set to 'Disabled'."
            exit 0
        } else {
            Write-Host "Audit Failed: 'Enable optional updates' is NOT set to 'Disabled'."
            Write-Host "Please manually set 'Computer Configuration\Policies\Administrative Templates\Windows Components\Windows Update\Manage updates offered from Windows Update\Enable optional updates' to 'Disabled'."
            exit 1
        }
    } else {
        Write-Host "Audit Failed: 'AllowOptionalContent' registry value is missing."
        Write-Host "Please manually set 'Computer Configuration\Policies\Administrative Templates\Windows Components\Windows Update\Manage updates offered from Windows Update\Enable optional updates' to 'Disabled'."
        exit 1
    }
} else {
    Write-Host "Audit Failed: Registry path for 'Enable optional updates' does not exist."
    Write-Host "Please manually set 'Computer Configuration\Policies\Administrative Templates\Windows Components\Windows Update\Manage updates offered from Windows Update\Enable optional updates' to 'Disabled' if applicable."
    exit 1
}
# ```
