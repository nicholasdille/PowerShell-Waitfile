function Get-TargetType {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name = '*'
    )

    $Types.Values | Where-Object { $_.Name -like $Name }
}