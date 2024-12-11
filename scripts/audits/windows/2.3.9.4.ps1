#```powershell
# PowerShell script to audit the setting of 'Microsoft network server: Disconnect clients when logon hours expire'

# Define the registry path and the desired value to audit
$regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters'
$regName = 'enableforcedlogoff'
$desiredValue = 1

# Check if the registry path exists
if (Test-Path -Path $regPath) {
    # Get the current value of the registry entry
    try {
        $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
        if ($currentValue.$regName -eq $desiredValue) {
            Write-Host "Audit Passed: 'Microsoft network server: Disconnect clients when logon hours expire' is set to 'Enabled'."
            exit 0
        } else {
            Write-Host "Audit Failed: 'Microsoft network server: Disconnect clients when logon hours expire' is NOT set to 'Enabled'."
            exit 1
        }
    } catch {
        Write-Host "Audit Failed: Unable to retrieve the registry setting."
        exit 1
    }
} else {
    Write-Host "Audit Failed: Registry path not found. Please ensure this setting is applied manually as described in the UI Path."
    exit 1
}
# ```
