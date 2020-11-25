#!/usr/bin/env pwsh

[CmdletBinding()]
Param(
    [ValidateSet("Windows", "Linux", "MacOS")]
    [string]$Platform = "Windows",
    [ValidateSet("Rider", "GoLand", "CLion", "IntelliJIdea", "PyCharm")]
    [string]$Product = "Rider",
    [string]$Version = "2020.2"
)

$ScriptsPath = split-path -Parent $MyInvocation.MyCommand.Definition
$RootPath = Split-Path -Parent $ScriptsPath
$KeymapsPath = Join-Path $RootPath "dotfiles" | `
               Join-Path -ChildPath "idea-keymaps"

# NOTE: This script will build the keymap file used by Rider and other JetBrains IDEs
#       At first we will only support running it on windows, because we use
#       home-manager (nix) on Linux and MacOS.

# TODO: Support all IDE's
if ($Product -ne "Rider") {
    Write-Host "We only suppport Rider (WIP)"
    exit 1
}

# TODO: Make files product dependent!!
$files = `
    "03_Cancelations.xml", `
    "05_VimCancelations.xml", `
    "07_File.xml", `
    "08_Editor.xml", `
    "10_CreateAndEdit.xml", `
    "20_AnalyzeAndExplore.xml", `
    "20_Rider_AnalyzeAndExplore.xml", `
    "30_VersionControl.xml", `
    "40_MasterYourIDE.xml", `
    "40_Rider_MasterYourIDE.xml", `
    "45_ToolWindows.xml", `
    "50_FindEverything.xml", `
    "60_NavigateFromSymbols.xml", `
    "60_Rider_NavigateFromSymbols.xml", `
    "70_NavigateInContext.xml", `
    "80_BuildRunAndDebug.xml", `
    "80_Rider_BuildRunAndDebug.xml", `
    "90_Rider_UnitTests.xml", `
    "95_RefactorAndCleanup.xml"

$keymapsInnerOutput = ($files | `
    ForEach-Object { Get-Content (Join-Path $KeymapsPath $_) -Raw}) `
    -join  [Environment]::NewLine

$keymapsOutput = '<keymap name="CustomMade" parent="$default" version="1" disable-mnemonics="false">', `
                 $keymapsInnerOutput, `
                 '</keymap>' -join [System.Environment]::NewLine

$jetBrainsProductVersionPath = Join-Path "JetBrains" "$Product$Version" | `
                               Join-Path -ChildPath "keymaps"

$keymapsOutputPath = switch -Exact ($Platform) {
    'Windows' { Join-Path $env:APPDATA $jetBrainsProductVersionPath }
    'Linux' { Join-Path $env:HOME ".config" | Join-Path -ChildPath $jetBrainsProductVersionPath  }
    'MacOS' { Join-Path $env:HOME "Library" | Join-Path -ChildPath "Application Support" | Join-Path -ChildPath $jetBrainsProductVersionPath }
}

# Set-Content will fail if the directories in the path have not been created
New-Item -Path $keymapsOutputPath -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null

# Set-Content will write new content or replace the existing content
Set-Content -Path (Join-Path $keymapsOutputPath "CustomMade.xml") -Value $keymapsOutput
