#```powershell
# PowerShell 7 Script to Audit "Disable OneSettings Downloads" Policy

# Define the registry path and expected value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection'
$registryValueName = 'DisableOneSettingsDownloads'
$expectedValue = 1

# Function to check the registry setting
Function Check-RegistrySetting {
    # Check if the registry key exists
    if (Test-Path $registryPath) {
        
        # Try to retrieve the registry value
        try {
            $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
        } catch {
            Write-Output "The registry value $registryValueName was not found."
            return $false
        }

        # Compare the actual value with the expected value
        if ($actualValue.$registryValueName -eq $expectedValue) {
            Write-Output "Audit Passed: '$registryValueName' is set to Enabled as required."
            return $true
        }
        else {
            Write-Output "Audit Failed: '$registryValueName' is not set to Enabled. Current value: $($actualValue.$registryValueName)"
            return $false
        }
    }
    else {
        Write-Output "Audit Failed: Registry path $registryPath does not exist."
        return $false
    }
}

# Perform the audit
if (Check-RegistrySetting) {
    exit 0  # Audit passed
} else {
    exit 1  # Audit failed
}
# ```
