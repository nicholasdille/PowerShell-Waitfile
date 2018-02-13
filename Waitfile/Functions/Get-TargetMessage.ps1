function Get-TargetMessage {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    if ($PSBoundParameters.ContainsKey('Name')) {
        if (Test-TargetMessage -Name $Name) {
            [pscustomobject]@{
                Name = $Name
                Message = $Messages[$Name]
            }
        }

    } else {
        $Messages.Keys | ForEach-Object {
            [pscustomobject]@{
                Name = $_
                Message = $Messages[$_]
            }
        }
    }
}