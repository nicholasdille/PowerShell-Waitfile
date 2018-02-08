function New-TargetType {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        "PSUseShouldProcessForStateChangingFunctions",
        "",
        Justification = "Creates in-memory object only."
    )]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [array]
        $Arguments = @()
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [scriptblock]
        $Test
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [scriptblock]
        $New
        ,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [scriptblock]
        $Remove
    )

    process {
        if ($Types.ContainsKey($Name)) {
            throw "Type $Name already exists"
        }
        Write-Verbose "Creating target type <$Name>"

        $Types[$Name] = [pscustomobject]@{
            Name       = $Name
            Arguments  = $Arguments
            Test       = $Test
            New        = $New
            Remove     = $Remove
            PSTypeName = 'WaitfileTargetType'
        }
    }
}