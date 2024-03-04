#Reference: https://code.visualstudio.com/docs/remote/devcontainerjson-reference#_lifecycle-scripts
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'Ignore'

#Perform a build so that it is cached in the precached layer. This will make both restore and delta compliations faster for actual devcontainer use
Import-Module $PSScriptRoot/../../build.psm1
Start-PSBuild -Restore -ErrorAction 'Continue'

#Alternative: Perform a dotnet restore only
#& dotnet restore ./src/powershell-unix
