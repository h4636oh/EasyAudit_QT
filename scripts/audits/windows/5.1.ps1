#```powershell
# PowerShell 7 script to audit the Microsoft FTP Service configuration
# The script checks if the service is disabled or not installed.

# Define the registry path and value to check
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\FTPSVC"
$regName = "Start"

# Function to audit the FTP Service configuration
function Audit-FTPService {
    try {
        # Check if the registry key exists
        if (Test-Path $regPath) {
            # Get the current Start value of the FTP service
            $startValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop

            # Check if the service is disabled (Start value of 4)
            if ($startValue.$regName -eq 4) {
                Write-Host "Audit Passed: FTP Service is disabled."
                exit 0
            }
            else {
                Write-Host "Audit Failed: FTP Service is not disabled. Current Start value: $($startValue.$regName)"
                exit 1
            }
        }
        else {
            Write-Host "Audit Passed: FTP Service is not installed."
            exit 0
        }
    }
    catch {
        Write-Host "Audit Failed: An error occurred - $_"
        exit 1
    }
}

# Execute the audit function
Audit-FTPService
# ```
