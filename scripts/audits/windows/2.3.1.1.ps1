#```powershell
# This PowerShell 7 script audits the setting that prevents users from adding new Microsoft accounts
# on the computer by checking a specific registry key.

# Define the registry path and value name
$regPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$valueName = 'NoConnectedUser'

# Attempt to read the registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Output "Audit FAILED: Unable to read registry key at $regPath. It may not exist or you do not have the required permissions."
    Write-Output "Please manually verify the group policy setting under: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options\\Accounts: Block Microsoft accounts"
    exit 1
}

# Verify if the registry value is set to the recommended setting (3)
if ($regValue.$valueName -eq 3) {
    Write-Output "Audit PASSED: 'Accounts: Block Microsoft accounts' is correctly set to prevent adding or logging on with Microsoft accounts."
    exit 0
} else {
    Write-Output "Audit FAILED: 'Accounts: Block Microsoft accounts' is not set to the recommended value."
    Write-Output "Please set the policy to: Users can't add or log on with Microsoft accounts."
    exit 1
}
# ```
# 
