#```powershell
# Script to audit the setting for "Do not allow supported Plug and Play device redirection"

# Define the registry path and value to check
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$registryName = "fDisablePNPRedir"

# Function to audit the registry setting
function Audit-RegistrySetting {
    try {
        # Attempt to get the registry value
        $regValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop
        
        # Check if the registry value is set to 1 (Enabled)
        if ($regValue.$registryName -eq 1) {
            Write-Host "Audit Passed: 'Do not allow supported Plug and Play device redirection' is set to 'Enabled'."
            exit 0
        } else {
            Write-Host "Audit Failed: 'Do not allow supported Plug and Play device redirection' is NOT set to 'Enabled'. Expected 1, found $($regValue.$registryName)."
            exit 1
        }
    } catch {
        Write-Host "Audit Failed: Unable to retrieve the setting. The key might not exist or access is denied."
        exit 1
    }
}

# Start the audit
Write-Host "Auditing registry setting for 'Do not allow supported Plug and Play device redirection'..."
Audit-RegistrySetting

# If manual check is recommended, prompt user
Write-Host "Please verify manually via Group Policy Management at the following path:"
Write-Host "Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Remote Desktop Services\\Remote Desktop Session Host\\Device and Resource Redirection\\Do not allow supported Plug and Play device redirection"
# ```
