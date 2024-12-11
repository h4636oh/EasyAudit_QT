#```powershell
# PowerShell script to audit the IRDP setting as per the security guidelines

# Function to check if the registry value for IRDP is set correctly
Function Test-IRDPSetting {
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    $registryName = "PerformRouterDiscovery"
    $expectedValue = 0

    # Check if the registry path exists
    if (Test-Path $registryPath) {
        # Get the registry value
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction SilentlyContinue

        # Check if the registry value matches the expected value
        if ($null -ne $currentValue) {
            if ($currentValue.$registryName -eq $expectedValue) {
                Write-Host "Audit Passed: IRDP is disabled as expected." -ForegroundColor Green
                return $true
            } else {
                Write-Host "Audit Failed: IRDP is not set to the recommended state. Current value: $($currentValue.$registryName)" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "Audit Failed: IRDP setting not found in the registry." -ForegroundColor Red
            return $false
        }
    } else {
        Write-Host "Audit Failed: Registry path does not exist." -ForegroundColor Red
        return $false
    }
}

# Perform the audit check
if (Test-IRDPSetting) {
    exit 0
} else {
    Write-Host "Please follow the manual remediation steps to disable IRDP via Group Policy." -ForegroundColor Yellow
    exit 1
}
# ```
