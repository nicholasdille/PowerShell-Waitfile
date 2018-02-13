function Invoke-Target {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
        ,
        [Parameter()]
        [ValidateSet('New', 'Remove')]
        [string]
        $Action = 'New'
        ,
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [int]
        $Level = 0
    )

    begin {
        $Indentation = 4
    }

    process {
        if ($PSBoundParameters.ContainsKey('Name')) {
            Write-Debug "Extracting target by name <$Name>"
            $Target = $Targets[$Name]

        } else {
            Write-Debug "Extracting default target"
            $Target = $Targets.Values | Where-Object { $_.Default }
        }

        if (@($Target).Count -ne 1) {
            throw "$(' ' * $Indentation * $Level)Need exactly one default target"
        }

        if ($Target.Type) {
            $TargetTypeTest = Invoke-Command -ScriptBlock (Get-TargetType -Name $Target.Type).Test -ArgumentList $Target.TypeArguments
            if ($Action -eq 'New' -and $TargetTypeTest -is [bool] -and $TargetTypeTest) {
                Write-Debug "Target <$($Target.Name)> already exists"
                return
            }
        }

        Write-Verbose "$(' ' * $Indentation * $Level)[$Level] Processing target $($Target.Name)"

        if ($Target.DependsOn) {
            foreach ($DependsOnItem in $Target.DependsOn) {
                Write-Verbose "$(' ' * 4 * $Level)[$Level] Invoking dependency <$DependsOnItem>"
                Invoke-Target -Name $DependsOnItem -Action $Action -Level ($Level + 1)
            }
        }

        if ($Target.Type) {
            Write-Verbose "$(' ' * $Indentation * $Level)[$Level] Invoking action on <$($Target.Name)>"
            Invoke-Command -ScriptBlock (Get-TargetType -Name $Target.Type).$Action -ArgumentList $Target.TypeArguments
        }
    }
}