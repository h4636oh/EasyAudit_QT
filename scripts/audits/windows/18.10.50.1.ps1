#```powershell
# PowerShell 7 Script to Audit OneDrive Usage Policy
# This script checks the registry setting for the Group Policy 'Prevent the usage of OneDrive for file storage'
# It ensures that the setting is configured to 'Enabled', which corresponds to a REG_DWORD value of 1.
# Exit 0 if the configuration is correct, otherwise exit 1.

try {
    # Define the registry path and the expected value
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
    $valueName = "DisableFileSyncNGSC"
    $expectedValue = 1

    # Check if the registry key exists
    if (Test-Path $registryPath) {
        # Get the registry value
        $actualValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop | Select-Object -ExpandProperty $valueName
        
        # Compare the actual value with the expected value
        if ($actualValue -eq $expectedValue) {
            Write-Host "The 'Prevent the usage of OneDrive for file storage' policy is set correctly." -ForegroundColor Green
            exit 0
        } else {
            Write-Host "The 'Prevent the usage of OneDrive for file storage' policy is NOT set correctly." -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "The registry path $registryPath does not exist. Please ensure that the policy setting is configured." -ForegroundColor Red
        exit 1
    }
} catch {
    # Handle unexpected errors
    Write-Host "An error occurred while checking the policy: $_" -ForegroundColor Red
    exit 1
}
# ```
# 
# This script performs an audit on the OneDrive usage policy by checking the specified registry setting to confirm if it is configured as recommended. It provides clear messages and exits with appropriate status codes based on the audit result.
