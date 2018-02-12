# Data structure for storing target types
$script:Types = @{}

# Data structure for storing targets
$script:Targets = @{}

# Data structure for passing information between targets
$script:Messages = @{}

# Import functions
Get-ChildItem -Path "$PSScriptRoot\Functions" -Filter '*.ps1' -Recurse | ForEach-Object {
    . "$($_.FullName)"
}

# Import pre-defined target types
Get-ChildItem -Path "$PSScriptRoot\TargetTypes" -Filter '*.ps1' -Recurse | ForEach-Object {
    . "$($_.FullName)"
}
