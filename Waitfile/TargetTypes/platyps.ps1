New-TargetType `
    -Name 'platyps' `
    -Arguments 'Path', 'ModuleRoot' `
    -Test {
        param([hashtable]$Arguments)

        Write-Information 'Checking whether to generate documentation'

        $DocsAreCurrent = $true
        Get-ChildItem -Path $Arguments.Path -Directory | Select-Object -ExpandProperty Name | ForEach-Object {
            Write-Host "Checking $_"

            $LatestSourceFile = Get-ChildItem -Path "$($Arguments.Path)\$_" -Filter '*.md' -Recurse | Sort-Object -Property LastWriteTime -Descending | Select-Object -First 1
            $TargetFile = @(Get-ChildItem -Path "$($Arguments.ModuleRoot)\$_" -Filter '*-help.xml')
            if ($TargetFile.Length -gt 1) {
                throw "Found more than one ($($TargetFile.Length)!) target documentation ($($TargetFile)). You need to rewrite this."
            }

            if (-not $TargetFile -or $LatestSourceFile.LastWriteTime -gt $TargetFile[0].LastWriteTime) {
                $DocsAreCurrent = $false
            }
        }

        if ($DocsAreCurrent) {
            Write-Information 'No need to generate the documentation'
        }
        $DocsAreCurrent
    } `
    -New {
        param([hashtable]$Arguments)

        Write-Information 'Testing documentation'
        #

        Write-Information 'Generating documentation'
        Get-ChildItem -Path $Arguments.Path -Directory | Select-Object -ExpandProperty Name | ForEach-Object {
            Write-Information "Processing $($Arguments.Path)\$_"
            New-ExternalHelp -Path "$($Arguments.Path)\$_" -OutputPath "$($Arguments.ModuleRoot)\$_" -Force | Out-Null
        }
    } `
    -Remove {
        param([hashtable]$Arguments)

        Write-Information 'Removing documentation'

        Get-ChildItem -Path $Arguments.Path -Directory | Select-Object -ExpandProperty Name | ForEach-Object {
            Write-Host "Processing $_"

            Get-ChildItem -Path "$($Arguments.ModuleRoot)\$_" -File | Remove-Item -Force
        }
    }