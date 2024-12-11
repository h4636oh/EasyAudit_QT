#```powershell
# PowerShell script to audit the User Account Control (UAC) setting for administrators in Admin Approval Mode.
# Specifically, it checks if the setting is 'Prompt for consent on the secure desktop' or 'Prompt for credentials on the secure desktop'.

# Define the registry path and value name
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "ConsentPromptBehaviorAdmin"

# Get the current registry value for ConsentPromptBehaviorAdmin
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $valueName

# Define acceptable values
$acceptableValues = @(1, 2)  # 1: Prompt for consent on the secure desktop, 2: Prompt for credentials on the secure desktop

# Check if the value is acceptable
if ($null -ne $currentValue -and $acceptableValues -contains $currentValue) {
    Write-Output "Audit Passed: ConsentPromptBehaviorAdmin is set to an acceptable value ($currentValue)."
    exit 0
} else {
    Write-Warning "Audit Failed: ConsentPromptBehaviorAdmin is not set to an acceptable value."
    Write-Output "Please manually navigate to 'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options' in the Group Policy Editor."
    Write-Output "Ensure 'User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode' is set to either 'Prompt for consent on the secure desktop' or 'Prompt for credentials on the secure desktop'."
    exit 1
}
# ```
