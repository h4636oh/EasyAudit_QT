#```powershell
# PowerShell script to audit the 'Allow unencrypted traffic' policy setting

# Define the registry path and the expected value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client'
$registryName = 'AllowUnencryptedTraffic'
$expectedValue = 0

# Function to check the registry value
function Test-AllowUnencryptedTraffic {
    try {
        # Get the current registry value
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop
        if ($currentValue.$registryName -eq $expectedValue) {
            Write-Output "Audit Passed: 'Allow unencrypted traffic' is set to 'Disabled'."
            return $true
        }
        else {
            Write-Output "Audit Failed: 'Allow unencrypted traffic' is not set to 'Disabled'."
            return $false
        }
    }
    catch {
        # If the registry key or value does not exist, audit fails
        Write-Output "Audit Failed: Unable to query registry value or value does not exist."
        return $false
    }
}

# Run the audit check
if (Test-AllowUnencryptedTraffic) {
    exit 0
} else {
    Write-Output "Please manually verify the Group Policy setting: Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Windows Remote Management (WinRM)\\WinRM Client\\Allow unencrypted traffic is set to 'Disabled'."
    exit 1
}
# ```
# 
