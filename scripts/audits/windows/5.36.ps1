#```powershell
# PowerShell 7 Script for auditing Windows Mobile Hotspot Service

# Check the registry key value to verify the Mobile Hotspot Service is set to 'Disabled'
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\icssvc'
$registryValueName = 'Start'
$expectedValue = 4

try {
    # Get the current value of the 'Start' DWORD in the specified registry path
    $currentValue = Get-ItemPropertyValue -Path $registryPath -Name $registryValueName -ErrorAction Stop

    # Compare the current value with the expected value (4)
    if ($currentValue -eq $expectedValue) {
        Write-Output "Audit passed: Windows Mobile Hotspot Service is set to 'Disabled'."
        exit 0
    } else {
        Write-Host "Audit failed: Windows Mobile Hotspot Service is NOT set to 'Disabled'. Current value: $currentValue" -ForegroundColor Red
        Write-Host "Please manually set the service to 'Disabled' via Group Policy Editor." -ForegroundColor Yellow
        exit 1
    }
} catch {
    # Handle cases where the registry path or value might not exist
    Write-Host "Error accessing the registry path: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Ensure the registry path $registryPath exists and the policy has been applied." -ForegroundColor Yellow
    exit 1
}
# ```
