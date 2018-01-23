$env:PSModulePath = "$env:PSModulePath;$((Get-Item -Path "$PSScriptRoot\..").FullName)"

Import-Module -Name Waitfile -Force

Describe 'Makefile' {
    It 'Add new type' {
        $Count = $Types.Keys.Count + 1
        New-TargetType -Name 'File' -Test {}
        $Types.Keys.Count | Should Be $Count
    }
    It 'Fails to add existing type' {
        $Count = $Types.Keys.Count
        { New-TargetType -Name 'File' -Test {} } | Should Throw
        $Types.Keys.Count | Should Be $Count
    }
    It 'Adds new target' {
        $Count = $Targets.Keys.Count + 1
        New-Target -Name 'Test1' -Type 'File' -Action {}
        $Targets.Keys.Count | Should Be $Count
    }
    It 'Adds second non-default target' {
        $Count = $Targets.Keys.Count + 1
        New-Target -Name 'Test2' -Type 'File' -DependsOn 'Test1' -Default
        $Targets.Keys.Count | Should Be $Count
    }
    It 'Fails to add existing target' {
        $Count = $Targets.Keys.Count
        { New-Target -Name 'Test2' -Type 'File' } | Should Throw
        $Targets.Keys.Count | Should Be $Count
    }
    It 'Fails to add on non-existent dependency' {
        { New-Target -Name 'Test3' -Type 'File' -DependsOn 'Test0' } | Should Throw
    }
    It 'Fails to add two default targets' {
        { New-Target -Name 'Test3' -Type 'File' -Default } | Should Throw
    }
}