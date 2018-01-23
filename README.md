# Introduction

Rudimentary replacement for `Makefile`

## Usage

Install this module:

```powershell
Install-Module -Name Waitfile
```

Using this module for a Docker image build:

```powershell
New-Target -Name 'Dockerfile' -Type 'FileCheck' -TypeArguments @{Name = 'Dockerfile'}
New-Target -Name 'Build' -Type 'DockerBuild' -DependsOn @('Dockerfile') -TypeArguments @{Registry = 'myregistry'; Name = 'myimage'; Tag = 'mytag'}
New-Target -Name 'Tag' -Type 'DockerTag' -DependsOn @('Build') -TypeArguments @{Registry = 'myregistry'; Name = 'myimage'; Tag1 = 'mytag'; Tag2 = 'alsomytag'}
New-Target -Name 'Push' -Type 'DockerPush' -DependsOn @('Tag') -TypeArguments @{Registry = 'myregistry'; Name = 'myimage'; Tag = 'alsomytag'}

New-Target -Name 'All' -Type 'Dummy' -DependsOn @('Push') -Default

Invoke-Target #-Action Remove
```