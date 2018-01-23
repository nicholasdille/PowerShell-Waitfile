function Get-Target {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name = '*'
    )

    $Targets.Values | Where-Object { $_.Name -like $Name }
}