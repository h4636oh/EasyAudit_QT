#```powershell
# PowerShell 7 Script to Audit IIS Admin Service Status

# Function to check the IIS Admin Service status
Function Test-IISAdminService {
    # Define the registry path and key
    $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\IISADMIN"
    $startValueName = "Start"
    
    # Check if the IIS Admin Service registry key exists
    if (Test-Path -Path $registryPath) {
        # Get the value of the 'Start' registry key
        $startValue = Get-ItemProperty -Path $registryPath -Name $startValueName -ErrorAction SilentlyContinue
        
        # Check if the Start value is 4 (Disabled)
        if ($startValue.$startValueName -eq 4) {
            Write-Output "Audit Passed: IIS Admin Service is Disabled."
            return $true
        } else {
            Write-Output "Audit Failed: IIS Admin Service is Enabled."
            return $false
        }
    } else {
        Write-Output "Audit Passed: IIS Admin Service is not installed."
        return $true
    }
}

# Execute the function and determine the script exit code
if (Test-IISAdminService) {
    exit 0  # Audit Passed
} else {
    # Remind user to manually ensure the service is set to Disabled or Not Installed
    Write-Host "Please ensure the IIS Admin Service is either Disabled or Not Installed via:"
    Write-Host "Navigate to: Computer Configuration -> Policies -> Windows Settings -> Security Settings -> System Services -> IIS Admin Service"
    Write-Host "Set to Disabled or ensure the service is not installed."
    
    exit 1  # Audit Failed
}
# ```
