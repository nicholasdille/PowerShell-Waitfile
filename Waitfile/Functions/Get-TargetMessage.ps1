function Get-TargetMessage {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name = '*'
    )

    $Messages | Where-Object { $_.Name -like $Name }
}