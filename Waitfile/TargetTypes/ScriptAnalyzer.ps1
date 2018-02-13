New-TargetType `
    -Name 'ScriptAnalyzer' `
    -Arguments 'Path' `
    -Test { $false } `
    -New {
            param([hashtable]$Arguments)

            Write-Information 'Running script analysis'
            $results = Invoke-ScriptAnalyzer -Path $Arguments.Path -Severity Error,Warning -Recurse
            if ($results) {
                $results | Select-Object -Property ScriptName,Line,RuleName,Severity,Message
                throw 'Failed script analysis. Build failed.'
            }

            Write-Information 'Collecting suppressed issues'
            $results = Invoke-ScriptAnalyzer -Path $Arguments.Path -SuppressedOnly -Recurse
            if ($results) {
                Write-Warning 'Some issues are suppressed from script analysis.'
            }
            New-TargetMessage -Name 'ScriptAnalysisSuppressedIssues' -Message $results
        } `
    -Remove {}