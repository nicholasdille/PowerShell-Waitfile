function New-Target {
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
        $DependsOn
        ,
        [Parameter()]
        [switch]
        $Default
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Type
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $TypeArguments = @{}
    )

    process {
        if ($Targets.ContainsKey($Name)) {
            throw "Target <$Name> already exists"
        }
        Write-Verbose "Creating target <$Name>"
        if (-not $Types.ContainsKey($Type)) {
            throw "Target type <$Type> does not exist"
        }
        if (Compare-Object -ReferenceObject @($Types[$Type].Arguments | Sort-Object) -DifferenceObject @($TypeArguments.Keys | Sort-Object)) {
            throw "Type arguments <$($TypeArguments.Keys -join ',')> do not match expectation <$($Types[$Type].Arguments -join ',')>"
        }
        foreach ($DependsOnItem in $DependsOn) {
            if (-not $Targets.ContainsKey($DependsOnItem)) {
                throw "Dependent target <$DependsOnItem> does not exist"
            }
        }
        if ($Default -and ($Targets.Values | Where-Object { $_.Default })) {
            throw "Default target already exists"
        }

        $Targets[$Name] = [pscustomobject]@{
            Name          = $Name
            DependsOn     = $DependsOn
            Default       = [bool]$Default
            Type          = $Type
            TypeArguments = $TypeArguments
            PSTypeName    = 'WaitfileTarget'
        }
    }
}