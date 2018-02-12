function Test-TargetMessage {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    [bool](Get-TargetMessage | Where-Object { $_.Name -ieq $Name })
}