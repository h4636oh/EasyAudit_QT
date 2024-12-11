#```powershell
# Script to audit the policy setting 'Turn off downloading of print drivers over HTTP'

# Define registry path and registry value expected
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$regName = "DisableWebPnPDownload"
$expectedValue = 1

# Check if the registry key exists
if (Test-Path $regPath) {
    # Get the registry value
    $actualValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

    # Compare the actual value with the expected value
    if ($actualValue.$regName -eq $expectedValue) {
        Write-Output "Audit Passed: The setting 'Turn off downloading of print drivers over HTTP' is enabled."
        exit 0
    }
    else {
        Write-Warning "Audit Failed: The setting 'Turn off downloading of print drivers over HTTP' is not enabled."
        Write-Output "Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\System\\Internet Communication Management\\Internet Communication settings' and set 'Turn off downloading of print drivers over HTTP' to 'Enabled'."
        exit 1
    }
}
else {
    Write-Warning "Audit Failed: The registry path $regPath does not exist."
    Write-Output "Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\System\\Internet Communication Management\\Internet Communication settings' and set 'Turn off downloading of print drivers over HTTP' to 'Enabled'."
    exit 1
}

# If script reaches here, unexpected error occurred
Write-Error "Unexpected error occurred during audit process."
exit 1
# ```
