#```powershell
# Define the registry path and key for the policy setting
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$registryKey = "FilterAdministratorToken"

# Fetch the current value of the admin approval mode setting
$currentValue = (Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue).$registryKey

# Check if the value is set to 1 which means 'Enabled'
if ($currentValue -eq 1) {
    Write-Output "Audit Passed: 'User Account Control: Admin Approval Mode for the Built-in Administrator account' is 'Enabled'."
    exit 0
} else {
    Write-Output "Audit Failed: 'User Account Control: Admin Approval Mode for the Built-in Administrator account' is NOT 'Enabled'."
    Write-Output "Please navigate to 'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options' and set 'User Account Control: Admin Approval Mode for the Built-in Administrator account' to 'Enabled'."
    exit 1
}
# ```
# 
