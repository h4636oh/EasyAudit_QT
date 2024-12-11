#```powershell
# PowerShell script to audit the configuration for the WarningLevel in the Security event log
# According to the provided guidelines, the script should check if the warning level is set to 90% or less

$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Eventlog\Security"
$registryValueName = "WarningLevel"
$expectedValue = 90

try {
    # Query the registry to get the current value of WarningLevel
    $currentWarningLevel = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

    if ($currentWarningLevel.$registryValueName -le $expectedValue) {
        Write-Output "Audit Passed: The 'WarningLevel' is set to $($currentWarningLevel.$registryValueName)%, which is 90% or less."
        exit 0
    }
    else {
        Write-Output "Audit Failed: The 'WarningLevel' is set to $($currentWarningLevel.$registryValueName)%, which is more than 90%."
        exit 1
    }
}
catch {
    Write-Output "Audit Failed: Unable to retrieve 'WarningLevel'. Please verify manually."
    # Suggest action to check manually
    Write-Output "Please navigate to Computer Configuration\\Policies\\Administrative Templates\\MSS (Legacy): Percentage threshold for the security event log."
    Write-Output "Verify that it is set to 'Enabled: 90% or less'."
    exit 1
}
# ```
# 
