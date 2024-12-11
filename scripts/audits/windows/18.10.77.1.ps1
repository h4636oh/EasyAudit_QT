#```powershell
# Script to audit the configuration of Windows Game Recording and Broadcasting setting

# Define the registry path and value name
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR'
$valueName = 'AllowGameDVR'
$expectedValue = 0

# Function to audit the setting
function Test-GameDVRSetting {
    try {
        # Attempt to get the value from the registry
        $value = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
        if ($value.$valueName -eq $expectedValue) {
            Write-Host "Audit Passed: Windows Game Recording and Broadcasting is disabled as expected."
            exit 0
        } else {
            Write-Host "Audit Failed: Windows Game Recording and Broadcasting is not disabled." -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "Audit Failed: Could not retrieve the GameDVR setting. Please check manually." -ForegroundColor Red
        Write-Host "Navigate to Computer Configuration\Policies\Administrative Templates\Windows Components\Windows Game Recording and Broadcasting and ensure it is set to 'Disabled'."
        exit 1
    }
}

# Run the audit function
Test-GameDVRSetting
# ```
