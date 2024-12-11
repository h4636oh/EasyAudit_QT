#```powershell
# PowerShell 7 Script to Audit 'Turn on e-mail scanning' Policy Setting

# Function to check the registry value for the policy
function Test-EmailScanningPolicy {
    # Define the registry path and value name
    $registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan'
    $valueName = 'DisableEmailScanning'

    # Try to retrieve the registry value
    try {
        $regValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
        # If the value is 0, email scanning is considered enabled
        if ($regValue.$valueName -eq 0) {
            Write-Output "Audit Pass: 'Turn on e-mail scanning' is enabled."
            return 0
        } else {
            Write-Output "Audit Fail: 'Turn on e-mail scanning' is not enabled."
            return 1
        }
    } catch {
        # Output an error message if the registry key or value does not exist
        Write-Output "Audit Fail: Registry path or value not found. Manual verification required."
        return 1
    }
}

# Execute the audit function and exit with appropriate status
$exitCode = Test-EmailScanningPolicy
exit $exitCode
# ```
