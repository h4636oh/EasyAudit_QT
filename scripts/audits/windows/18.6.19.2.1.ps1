# This script audits the registry setting for disabling IPv6 components.
# It checks if 'DisabledComponents' under 'HKLM\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters' is set to 0xff (255).

$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters'
$registryName = 'DisabledComponents'
$expectedValue = 0xff

# Check if the registry path exists
if (-not (Test-Path -Path $registryPath)) {
    Write-Host "Registry path does not exist: $registryPath. Please verify that the policy is configured." -ForegroundColor Red
    Exit 1
}

# Fetch the current value from the registry
try {
    # Check if the registry value exists
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue

    # If the value doesn't exist
    if ($null -eq $currentValue) {
        Write-Host "Registry value '$registryName' does not exist. Ensure the value is configured to disable IPv6." -ForegroundColor Red
        Exit 1
    }

    # Get the actual registry value
    $currentValue = $currentValue.$registryName

} catch {
    Write-Host "Failed to retrieve registry value. Ensure you have the required permissions and the path is correct." -ForegroundColor Red
    Exit 1
}

# Check if the current value matches the expected value
if ($currentValue -eq $expectedValue) {
    Write-Host "Audit Passed: IPv6 is disabled as per the recommendation." -ForegroundColor Green
    Exit 0
} else {
    Write-Host "Audit Failed: IPv6 is NOT disabled. Current value: $currentValue. Expected value: $expectedValue" -ForegroundColor Yellow
    Write-Host "Please navigate to Control Panel > Network and Internet > Network Connections, right-click on your connection, select Properties, and ensure all unchecked boxes for Internet Protocol Version 6 (TCP/IPv6)." -ForegroundColor Yellow
    Exit 1
}
