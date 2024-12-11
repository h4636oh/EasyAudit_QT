#```powershell
# Ensure the script adheres to PowerShell 7 syntax and best practices.
# Script Objective: Audit if the 'Allow Use of Camera' setting is Disabled in the registry.

# Define the registry path and the expected value
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Camera"
$regKey = "AllowCamera"
$expectedValue = 0

# Check if the registry key exists
if (Test-Path $regPath) {
    # Get the actual value from the registry
    $actualValue = Get-ItemProperty -Path $regPath -Name $regKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $regKey
    
    # Check if the actual value matches the expected value
    if ($actualValue -eq $expectedValue) {
        Write-Host "Audit Passed: Camera use is disabled as expected."
        exit 0
    }
    else {
        Write-Host "Audit Failed: Camera use is not disabled. Current value: $actualValue. Expected value: $expectedValue."
        exit 1
    }
}
else {
    Write-Host "Audit Failed: Registry path '$regPath' does not exist. Camera policy might not be set."
    exit 1
}
# ```
