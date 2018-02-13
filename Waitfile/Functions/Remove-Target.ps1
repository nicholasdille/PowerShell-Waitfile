function Remove-Target {
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    begin {
        if (-not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = $PSCmdlet.SessionState.PSVariable.GetValue('ConfirmPreference')
        }
        if (-not $PSBoundParameters.ContainsKey('WhatIf')) {
            $WhatIfPreference = $PSCmdlet.SessionState.PSVariable.GetValue('WhatIfPreference')
        }
    }

    process {
        if (Get-Target | Where-Object { $_.DependsOn -contains $Name }) {
            throw "Unable to remove target $Name because other target depend on it"
        }
        if ($Force -or $PSCmdlet.ShouldProcess("Remove target named '$Name'?")) {
            $Targets.Remove($Name)
        }
    }
}