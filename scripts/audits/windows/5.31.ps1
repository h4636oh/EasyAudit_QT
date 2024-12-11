#```powershell
# Define the registry path and name
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\upnphost"
$registryName = "Start"
$desiredValue = 4

# Function to audit the UPnP Device Host service
function Audit-UPnPDeviceHost {
    try {
        # Get the current value of the registry key
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop

        # Check if the current value matches the desired value
        if ($currentValue.$registryName -eq $desiredValue) {
            Write-Output "Audit Passed: UPnP Device Host is configured correctly."
            exit 0
        } else {
            Write-Output "Audit Failed: UPnP Device Host is not configured as desired. Please set to Disabled manually."
            exit 1
        }
    } catch {
        Write-Output "Error accessing the registry. Ensure you have the necessary permissions."
        exit 1
    }
}

# Execute the audit function
Audit-UPnPDeviceHost
# ```
