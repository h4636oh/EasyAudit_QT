#```powershell
# PowerShell 7 Script to Audit Event Log Behavior for Maximum File Size

# Function to Check Registry Setting
function Check-EventLogPolicy {
    # Define the registry path and the expected value
    $regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
    $regName = "Retention"
    $expectedValue = "0"  # 'Disabled' corresponds to a value of "0"

    # Try to get the registry value
    try {
        $actualValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
        if ($actualValue.$regName -eq $expectedValue) {
            Write-Output "Audit Passed: The policy setting for 'Application: Control Event Log behavior when the log file reaches its maximum size' is set to 'Disabled'."
            Exit 0
        }
        else {
            Write-Output "Audit Failed: The policy setting for 'Application: Control Event Log behavior when the log file reaches its maximum size' is NOT set to 'Disabled'. Actual value: $($actualValue.$regName)"
            Exit 1
        }
    }
    catch {
        Write-Output "Audit Failed: Unable to retrieve registry value. It may not be set or path might not exist."
        Exit 1
    }
}

# Main Audit Check
Check-EventLogPolicy
# ```
# 
# This script checks the registry setting for Event Log behavior when the log file reaches its maximum size, ensuring it is set to 'Disabled'. If the setting meets the expected configuration, the script exits with status 0; otherwise, it exits with status 1.
