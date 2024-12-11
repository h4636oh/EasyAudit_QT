#```powershell
# PowerShell 7 Script to Audit Remote Desktop Configuration Service

# Define constants
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\SessionEnv"
$registryValueName = "Start"
$expectedValue = 4

# Function to check the registry value
function Test-RemoteDesktopConfiguration {
    try {
        # Get the registry value
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

        # Check if the current value matches the expected value
        if ($currentValue.$registryValueName -eq $expectedValue) {
            Write-Output "Audit Passed: Remote Desktop Configuration service is set to Disabled."
            return $true
        } else {
            Write-Output "Audit Failed: Remote Desktop Configuration service is not set to Disabled."
            return $false
        }
    } catch {
        # Handle cases where the registry key or value doesn't exist or other errors
        Write-Output "Error: Unable to retrieve the registry value. Please verify if the path and value name are correct."
        return $false
    }
}

# Main script execution
$success = Test-RemoteDesktopConfiguration

# Prompt user for manual check and exit code accordingly
if (-not $success) {
    Write-Output "Reminder: Navigate to Computer Configuration\Policies\Windows Settings\Security Settings\System Services\Remote Desktop Configuration and ensure it is set to Disabled."
    exit 1
} else {
    exit 0
}
# ```
