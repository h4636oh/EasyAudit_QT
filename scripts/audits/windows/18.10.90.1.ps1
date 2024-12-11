#```powershell
# PowerShell 7 script to audit if 'Allow clipboard sharing with Windows Sandbox' is set to 'Disabled'.

# Define the registry path and value
$regPath = 'HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Sandbox'
$regName = 'AllowClipboardRedirection'
$expectedValue = 0

# Check if the registry key and value exist
if (Test-Path -Path $regPath) {
    $actualValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

    # Validate the registry value
    if ($null -ne $actualValue -and $actualValue.$regName -eq $expectedValue) {
        Write-Output "Audit Passed: 'Allow clipboard sharing with Windows Sandbox' is set to 'Disabled'."
        exit 0
    }
    else {
        Write-Warning "Audit Failed: 'Allow clipboard sharing with Windows Sandbox' is not set to 'Disabled'."
        Write-Output "Please manually verify the setting at: Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Windows Sandbox\\Allow clipboard sharing with Windows Sandbox"
        exit 1
    }
}
else {
    Write-Warning "Audit Failed: Registry path $regPath does not exist."
    Write-Output "Please manually verify the setting at: Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Windows Sandbox\\Allow clipboard sharing with Windows Sandbox"
    exit 1
}
# ```
