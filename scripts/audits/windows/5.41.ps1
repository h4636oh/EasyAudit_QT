#```powershell
# PowerShell script to audit Xbox Accessory Management Service status

# Define the registry path and value
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\XboxGipSvc"
$registryValueName = "Start"
$expectedValue = 4 # Disabled state for the service

# Function to check the registry value
function Test-XboxAccessoryManagementService {
    try {
        $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop
        if ($actualValue.$registryValueName -eq $expectedValue) {
            Write-Host "Audit passed: Xbox Accessory Management Service is correctly set to 'Disabled'."
            exit 0
        } else {
            Write-Host "Audit failed: Xbox Accessory Management Service is NOT set to 'Disabled'."
            exit 1
        }
    } catch {
        Write-Host "Audit failed: Unable to retrieve registry value. Service might not be installed."
        exit 1
    }
}

# Execute the audit function
Test-XboxAccessoryManagementService
# ```
