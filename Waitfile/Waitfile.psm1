# Data structure for storing target types
$script:Types = @{}

# Data structure for storing targets
$script:Targets = @{}

# Import functions
Get-ChildItem -Path "$PSScriptRoot\Functions" -Filter '*.ps1' -Recurse | ForEach-Object {
    . "$($_.FullName)"
}

# Import pre-defined target types
Get-ChildItem -Path "$PSScriptRoot\TargetTypes" -Filter '*.ps1' -Recurse | ForEach-Object {
    . "$($_.FullName)"
}
