#```powershell
# PowerShell 7 script to audit 'MSS: (TcpMaxDataRetransmissions IPv6)' Group Policy setting

# Define the registry path and value name
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters"
$registryValueName = "TcpMaxDataRetransmissions"
$desiredValue = 3

# Function to check the registry setting
function Check-TcpMaxDataRetransmissions {
    try {
        # Attempt to read the registry value
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

        # Check if the current value matches the desired value
        if ($currentValue.$registryValueName -eq $desiredValue) {
            Write-Output "Audit Passed: TcpMaxDataRetransmissions is set to $desiredValue."
            return $true
        } else {
            Write-Output "Audit Failed: TcpMaxDataRetransmissions is set to $($currentValue.$registryValueName), expected $desiredValue."
            return $false
        }
    } catch {
        # Handle the case where the registry value does not exist
        Write-Output "Audit Failed: Could not find TcpMaxDataRetransmissions at $registryPath. Ensure the registry setting exists."
        return $false
    }
}

# Start the audit
if (Check-TcpMaxDataRetransmissions) {
    exit 0
} else {
    Write-Output "Please manually configure the setting as described in the remediation section."
    exit 1
}
# ```
