#```powershell
# PowerShell 7 script to audit the Remote Desktop Services policy for secure RPC communication

# Exit code variable to track audit status
$exitCode = 0

# Registry path and value to audit
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$registryValueName = 'fEncryptRPCTraffic'
$expectedValue = 1

# Function to check if secure RPC communication is set correctly
function Test-SecureRPCCommunication {
    # Check if registry key exists
    if (Test-Path $registryPath) {
        # Get the registry value
        $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

        # If registry value exists, compare it to expected value
        if ($null -ne $actualValue) {
            if ($actualValue.$registryValueName -eq $expectedValue) {
                Write-Output "Audit Passed: Secure RPC communication is enabled as required."
            } else {
                Write-Output "Audit Failed: Secure RPC communication is NOT enabled. Please configure it manually."
                $exitCode = 1
            }
        } else {
            Write-Output "Audit Failed: Could not find the registry value. Please ensure the policy is set manually."
            $exitCode = 1
        }
    } else {
        Write-Output "Audit Failed: Registry path not found. Please ensure the policy is set manually."
        $exitCode = 1
    }
}

# Execute the audit function
Test-SecureRPCCommunication

# Exit the script with the appropriate status code
exit $exitCode
# ```
