function Remove-Target {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    $Targets.Remove($Name)
}