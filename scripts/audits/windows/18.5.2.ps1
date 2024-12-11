#```powershell
# Title: 18.5.2 (L1) Ensure 'MSS: (DisableIPSourceRouting IPv6) IP source routing protection level' is set to 'Enabled: Highest protection, source routing is completely disabled' (Automated)

# Description: This script audits the setting of IP source routing protection to ensure it is disabled as per security guidelines.
# Script should only audit; it must not make any changes to the system configuration.

# Define the registry path and the expected value
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters'
$registryValueName = 'DisableIPSourceRouting'
$expectedValue = 2

# Check if the registry key exists
if (Test-Path $registryPath) {
    # Get the current value of the registry setting
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

    # Check if the current value matches the expected value
    if ($null -ne $currentValue -and $currentValue.$registryValueName -eq $expectedValue) {
        Write-Output "Audit Passed: The value of '$registryValueName' is set correctly to '$expectedValue'."
        exit 0
    } else {
        Write-Warning "Audit Failed: The value of '$registryValueName' is not set correctly. Please ensure it is set to '$expectedValue'."
        exit 1
    }
} else {
    Write-Warning "Audit Failed: The registry path '$registryPath' does not exist. Please ensure the MSS-legacy GPO templates are added and configured."
    exit 1
}

# If manual verification is needed, prompt the user
Write-Warning "Manual Action Required: Please verify via Group Policy Editor that 'MSS: (DisableIPSourceRouting IPv6)' is set to 'Enabled: Highest protection, source routing is completely disabled'."
# ```
