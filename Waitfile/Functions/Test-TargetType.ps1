function Test-TargetType {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $TypeArguments
        ,
        [Parameter()]
        [ValidateSet('Test', 'New', 'Remove')]
        [string]
        $Action = 'Test'
    )

    $Type = Get-TargetType -Name $Name
    Invoke-Command -ScriptBlock $Type.$Action -ArgumentList $TypeArguments
}