#Reference: https://code.visualstudio.com/docs/remote/devcontainerjson-reference#_lifecycle-scripts
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'Ignore'

(Get-ChildItem).FullName

#Link Feature-Installed PowerShell to /usr/bin/pwsh, some vscode tasks hardcode this path
New-Item -ItemType SymbolicLink -Path /usr/bin/pwsh -Value /usr/local/lib/pwsh/pwsh


Import-Module ./build.psm1

#For local devcontainers, sometimes permissions can end up mixed. Since Git 2.25, this can prevent git from working
& git config --global --add safe.directory $(Get-Location)

# If we are rebuilding the container, we probably want to reset our build environment too
Start-PSBuild -Clean

#Bootstrap initial requirements such as downloading the appropriate dotnet
Start-PSBootstrap

#Bootstrap dotnet 7.0 for C# dev kit Install-Dotnet can't install additional versions so we go to the core script
try {
    & ([ScriptBlock]::Create((Invoke-WebRequest -UseBasicParsing 'https://dot.net/v1/dotnet-install.ps1'))) -Channel 7.0 -RunTime dotnet -Architecture x64
} catch {
    Write-Warning $PSItem
}
