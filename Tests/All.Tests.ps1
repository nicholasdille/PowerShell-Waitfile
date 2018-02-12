if ($env:PSModulePath -notlike '*Waitfile*') {
    $env:PSModulePath = "$((Get-Item -Path "$PSScriptRoot\..").FullName);$env:PSModulePath"
}

Import-Module -Name Waitfile -Force -ErrorAction 'Stop'

Describe 'Makefile' {
    It 'Add new type' {
        $Count = @(Get-TargetType).Count + 1
        New-TargetType -Name 'File' -Test {} -New {} -Remove {}
        @(Get-TargetType).Count | Should Be $Count
    }
    It 'Fails to add existing type' {
        $Count = @(Get-TargetType).Count
        { New-TargetType -Name 'File' -Test {} -New {} -Remove {} } | Should Throw
        @(Get-TargetType).Count | Should Be $Count
    }
    It 'Adds new target' {
        $Count = @(Get-Target).Count + 1
        New-Target -Name 'Test1' -Type 'File'
        @(Get-Target).Count | Should Be $Count
    }
    It 'Adds second target' {
        $Count = @(Get-Target).Count + 1
        New-Target -Name 'Test2' -Type 'File' -DependsOn 'Test1' -Default
        @(Get-Target).Count | Should Be $Count
    }
    It 'Fails to add existing target' {
        $Count = @(Get-Target).Count
        { New-Target -Name 'Test2' -Type 'File' } | Should Throw
        @(Get-Target).Count | Should Be $Count
    }
    It 'Fails to add on non-existent dependency' {
        { New-Target -Name 'Test3' -Type 'File' -DependsOn 'Test0' } | Should Throw
    }
    It 'Fails to add two default targets' {
        { New-Target -Name 'Test3' -Type 'File' -Default } | Should Throw
    }
    It 'Invokes a target' {
        function Test-InvokeTargetTest {}
        function Test-InvokeTargetNew {}
        function Test-InvokeTargetRemove {}
        Mock Test-InvokeTargetTest {}
        Mock Test-InvokeTargetNew {}
        Mock Test-InvokeTargetRemove {}
        Clear-Target -Confirm:$false
        New-TargetType -Name 'TargetTest' -Test { Test-InvokeTargetTest } -New { Test-InvokeTargetNew } -Remove { Test-InvokeTargetRemove }
        New-Target -Name 'TargetTest' -Type 'TargetTest' -Default
        Invoke-Target -Action New
        Assert-MockCalled -CommandName Test-InvokeTargetTest -Times 1 -Exactly
        Assert-MockCalled -CommandName Test-InvokeTargetNew -Times 1 -Exactly
        Invoke-Target -Action Remove
        Assert-MockCalled -CommandName Test-InvokeTargetTest -Times 2 -Exactly
        Assert-MockCalled -CommandName Test-InvokeTargetNew -Times 1 -Exactly
        Assert-MockCalled -CommandName Test-InvokeTargetRemove -Times 1 -Exactly
    }
    It 'Clears the targets' {
        Clear-Target -Confirm:$false
        @(Get-Target).Count | Should Be 0
    }
    It 'Stores a message' {
        Clear-TargetMessage -Confirm:$false
        (Get-TargetMessage).Count | Should Be 0
        New-TargetMessage -Name 'TestMessage' -Message 'My message'
        (Get-TargetMessage).Count | Should Be 1
    }
    It 'Removes a message' {
        (Get-TargetMessage).Count | Should Be 1
        Remove-TargetMessage -Name 'TestMessage' -Confirm:$false
        (Get-TargetMessage).Count | Should Be 0
    }
    Clear-TargetMessage -Confirm:$false
    New-TargetType -Name 'Message' -Arguments 'Name' `
        -Test {
            param([hashtable]$Arguments)
            Test-TargetMessage -Name $Arguments.Name
        } `
        -New {
            param([hashtable]$Arguments)
            New-TargetMessage -Name $Arguments.Name -Message 'Test message'
        } `
        -Remove {
            param([hashtable]$Arguments)
            Remove-TargetMessage -Name $Arguments.Name -Confirm:$false
        }
    New-Target -Name 'MessageTester' -Type 'Message' -TypeArguments @{Name = 'Test'}
    Mock Test-TargetMessage {}
    Mock New-TargetMessage {}
    Mock Remove-TargetMessage {}
    It 'Stores a message while running a target' {
        Invoke-Target -Name 'MessageTester' -Action New
        Assert-MockCalled -CommandName 'Test-TargetMessage' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'New-TargetMessage' -Times 1 -Exactly
    }
    It 'Removes a message while running a target' {
        Invoke-Target -Name 'MessageTester' -Action Remove
        Assert-MockCalled -CommandName 'Test-TargetMessage' -Times 2 -Exactly
        Assert-MockCalled -CommandName 'New-TargetMessage' -Times 1 -Exactly
        Assert-MockCalled -CommandName 'Remove-TargetMessage' -Times 1 -Exactly
    }
}