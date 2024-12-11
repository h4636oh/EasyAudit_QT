#```powershell
# Audit Script: Ensure 'MSS: (DisableIPSourceRouting) IP source routing protection level' is set to 'Enabled: Highest protection, source routing is completely disabled'

# Define the registry path and the expected value
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters'
$registryName = 'DisableIPSourceRouting'
$expectedValue = 2

# Function to check the registry setting
function Test-IPSourceRoutingSetting {
    try {
        # Get the current value from the registry
        $currentValue = Get-ItemPropertyValue -Path $registryPath -Name $registryName -ErrorAction Stop

        # Compare the current value with the expected value
        if ($currentValue -eq $expectedValue) {
            Write-Output "Audit Passed: 'DisableIPSourceRouting' is set to the expected value ($expectedValue)."
            exit 0
        }
        else {
            Write-Output "Audit Failed: 'DisableIPSourceRouting' is not set to the expected value. Current value is $currentValue. Please set it manually."
            exit 1
        }
    }
    catch {
        Write-Output "Audit Failed: Could not retrieve registry value for 'DisableIPSourceRouting'. Ensure the registry path and name are correct, and review accessibility permissions."
        exit 1
    }
}

# Execute the function to perform the audit
Test-IPSourceRoutingSetting
# ```
# 
