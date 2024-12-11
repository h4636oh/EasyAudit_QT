# Description: This script audits if the "Do not suggest third-party content in Windows spotlight" policy is enabled.
# This policy prevents Windows from suggesting apps and content from third-party software publishers.
# Exit 0: Audit passed (policy is enabled), Exit 1: Audit failed (policy is not enabled).

# Set the registry path and key
$registryPath = 'HKU:\[USER SID]\Software\Policies\Microsoft\Windows\CloudContent'
$registryKey = 'DisableThirdPartySuggestions'

# Retrieve the User SID for the current session using WindowsIdentity.GetCurrent()
$userSid = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value

# Construct the full registry path for the current user
$fullRegistryPath = $registryPath -replace '\[USER SID\]', $userSid

# Function to audit the registry setting
function Audit-ThirdPartyContentPolicy {
    try {
        # Check if the registry key exists and retrieve its value
        $regValue = Get-ItemProperty -Path $fullRegistryPath -Name $registryKey -ErrorAction Stop

        # Validate the value of the registry key
        if ($regValue.$registryKey -eq 1) {
            Write-Host "Audit Passed: 'Do not suggest third-party content in Windows spotlight' is enabled."
            exit 0
        } else {
            Write-Host "Audit Failed: 'Do not suggest third-party content in Windows spotlight' is not enabled."
            exit 1
        }
    } catch {
        # Handle the case where the registry key is not found, indicating it's not set to the recommended value
        Write-Host "Audit Failed: 'Do not suggest third-party content in Windows spotlight' is not enabled or the registry key does not exist."
        exit 1
    }
}

# Prompt users if manual action is required
Write-Host "Please ensure the following Group Policy is set manually if needed:"
Write-Host "User Configuration -> Policies -> Administrative Templates -> Windows Components -> Cloud Content -> 'Do not suggest third-party content in Windows spotlight' is set to 'Enabled'"

# Run the audit function
Audit-ThirdPartyContentPolicy
