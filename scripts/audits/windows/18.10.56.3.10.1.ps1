#```powershell
# PowerShell 7 script to audit the policy setting for 'Set time limit for active but idle Remote Desktop Services sessions'

# Define registry path and value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$regName = "MaxIdleTime"
$recommendedMaxIdleTime = 900000 # 15 minutes in milliseconds

# Check if the registry path and key exist
if (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue) {
    # Retrieve the current MaxIdleTime value
    $currentValue = Get-ItemProperty -Path $regPath -Name $regName | Select-Object -ExpandProperty $regName

    # Check if the current value is within the recommended range
    if ($currentValue -gt 0 -and $currentValue -le $recommendedMaxIdleTime) {
        Write-Output "Audit Passed: MaxIdleTime is set to a recommended value of $currentValue milliseconds."
        exit 0
    } else {
        Write-Output "Audit Failed: MaxIdleTime is not within the recommended setting. Current setting is $currentValue. Recommended is 15 minutes or less, but not 0."
        exit 1
    }
} else {
    Write-Output "Audit Failed: MaxIdleTime is not set. You must configure this setting manually via Group Policy."
    Write-Output "Navigate to Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Remote Desktop Services -> Remote Desktop Session Host -> Session Time Limits"
    Write-Output "Then set 'Set time limit for active but idle Remote Desktop Services sessions' to 'Enabled: 15 minutes or less, but not Never (0)'."
    exit 1
}
# ```
