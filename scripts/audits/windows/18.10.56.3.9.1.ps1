#```powershell
# PowerShell 7 script to audit the 'Always prompt for password upon connection' setting

# Registry path and value
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$regName = 'fPromptForPassword'
$desiredValue = 1

# Retrieve the current registry value
try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
} catch {
    Write-Output "The registry key does not exist. The policy may not be configured."
    Write-Output "Please manually verify via Group Policy at the following path:"
    Write-Output "Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Remote Desktop Services -> Remote Desktop Session Host -> Security -> Always prompt for password upon connection"
    Exit 1
}

# Check if the policy is set to the desired value
if ($currentValue.$regName -eq $desiredValue) {
    Write-Output "Audit Passed: 'Always prompt for password upon connection' is set to 'Enabled'."
    Exit 0
} else {
    Write-Output "Audit Failed: 'Always prompt for password upon connection' is NOT set to 'Enabled'."
    Write-Output "Please manually verify and set it via Group Policy at the following path: "
    Write-Output "Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Remote Desktop Services -> Remote Desktop Session Host -> Security -> Always prompt for password upon connection"
    Exit 1
}
# ```
