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
        [Parameter(ParameterSetName='FullTarget', Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Type
        ,
        [Parameter(ParameterSetName='FullTarget')]
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $TypeArguments = @{}
        ,
        [Parameter(ParameterSetName='PhonyTarget', Mandatory)]
        [Parameter(ParameterSetName='FullTarget')]
        [ValidateNotNullOrEmpty()]
        [array]
        $DependsOn
        ,
        [Parameter()]
        [switch]
        $Default
    )

    process {
        if ($Targets.ContainsKey($Name)) {
            throw "Target <$Name> already exists"
        }
        if ($PSCmdlet.ParameterSetName -ieq 'FullTarget') {
            if (-not $Types.ContainsKey($Type)) {
                throw "Target type <$Type> does not exist"
            }
            if (Compare-Object -ReferenceObject @($Types[$Type].Arguments | Sort-Object) -DifferenceObject @($TypeArguments.Keys | Sort-Object)) {
                throw "Type arguments <$($TypeArguments.Keys -join ',')> do not match expectation <$($Types[$Type].Arguments -join ',')>"
            }
        }
        if ($PSBoundParameters.ContainsKey('DependsOn')) {
            foreach ($DependsOnItem in $DependsOn) {
                if (-not $Targets.ContainsKey($DependsOnItem)) {
                    throw "Dependent target <$DependsOnItem> does not exist"
                }
            }
        }
        if ($Default -and ($Targets.Values | Where-Object { $_.Default })) {
            throw "Default target already exists"
        }

        Write-Verbose "Creating target <$Name>"
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