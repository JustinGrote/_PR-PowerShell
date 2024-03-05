#Reference: https://code.visualstudio.com/docs/remote/devcontainerjson-reference#_lifecycle-scripts
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'Ignore'

Get-ChildItem env:

#Link Feature-Installed PowerShell to /usr/bin/pwsh, some vscode tasks hardcode this path
New-Item -ItemType SymbolicLink -Path /usr/bin/pwsh -Value /usr/local/lib/pwsh/pwsh


Import-Module ./build.psm1

#For local devcontainers, sometimes permissions can end up mixed. Since Git 2.25, this can prevent git from working
& git config --global --add safe.directory $(Get-Location)

# If we are rebuilding the container, we probably want to reset our build environment too
Start-PSBuild -Clean

#Bootstrap initial requirements such as downloading the appropriate dotnet
Start-PSBootstrap

#Bootstrap dotnet 7.0 for C# dev kit
& bash dotnet-install.sh -Channel $env:CSHARP_DEV_KIT_RUNTIME_CHANNEL -Runtime dotnet
