[CmdletBinding()]
param (
    [string[]] $Task = 'default'
)

Import-Module psake -Verbose:$false -ErrorAction Stop
$psakeParams = @{
    buildFile = "$($PSScriptRoot)/Build/psake.ps1"
    taskList  = $Task
    Verbose   = ($VerbosePreference -eq 'Continue')
}
Invoke-psake @psakeParams
# exit ([int](-not $psake.build_success))