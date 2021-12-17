#!/usr/bin/env pwsh

[CmdletBinding()]
Param(
    [ValidateSet("Windows", "Linux", "MacOS")]
    [string]$Platform = "Windows",
    [ValidateSet("Rider", "GoLand", "CLion", "IntelliJIdea", "PyCharm", "WebStorm")]
    [string]$Product = "Rider",
    [string]$Version = "2021.3"
)

$ScriptsPath = split-path -Parent $MyInvocation.MyCommand.Definition
$RootPath = Split-Path -Parent $ScriptsPath
$DotfilesPath = Join-Path $RootPath "dotfiles"
$KeymapsPath = Join-Path $DotfilesPath "idea-keymaps"

# NOTE: This script will build the keymap file used by Rider and other JetBrains IDEs
#       At first we will only support running it on windows, because we use
#       home-manager (nix) on Linux and MacOS.

# TODO: Support all IDE's
if ($Product -ne "Rider") {
    Write-Host "We only suppport Rider (WIP)"
    exit 1
}

#
# ideavimrc
#

# Files to build .ideavimrc
$ideavimrc_files = `
    "vimrc.base", `
    "vimrc.idea"

$ideavimrcOutput = ($ideavimrc_files | `
    ForEach-Object { Get-Content (Join-Path $DotfilesPath $_) -Raw}) `
    -join  [Environment]::NewLine

# windows does not support XDG
$ideavimrcOutputPath = $env:HOME

# Set-Content will fail if the directories in the path have not been created
New-Item -Path $ideavimrcOutputPath -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null

# Set-Content will write new content or replace the existing content
Set-Content -Path (Join-Path $ideavimrcOutputPath ".ideavimrc") -Value $ideavimrcOutput

#
# keymap
#

# TODO: Make files product dependent!!
$keymap_files = `
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

$keymapInnerOutput = ($keymap_files | `
    ForEach-Object { Get-Content (Join-Path $KeymapsPath $_) -Raw}) `
    -join  [Environment]::NewLine

$keymapOutput = '<keymap name="CustomMade" parent="$default" version="1" disable-mnemonics="false">', `
                 $keymapInnerOutput, `
                 '</keymap>' -join [System.Environment]::NewLine

$jetBrainsProductVersionPath = Join-Path "JetBrains" "$Product$Version" | `
                               Join-Path -ChildPath "keymaps"

$keymapOutputPath = switch -Exact ($Platform) {
    'Windows' { Join-Path $env:APPDATA $jetBrainsProductVersionPath }
    'Linux' { Join-Path $env:HOME ".config" | Join-Path -ChildPath $jetBrainsProductVersionPath  }
    'MacOS' { Join-Path $env:HOME "Library" | Join-Path -ChildPath "Application Support" | Join-Path -ChildPath $jetBrainsProductVersionPath }
}

# Set-Content will fail if the directories in the path have not been created
New-Item -Path $keymapOutputPath -ItemType Directory -Force -ErrorAction SilentlyContinue | out-null

# Set-Content will write new content or replace the existing content
Set-Content -Path (Join-Path $keymapOutputPath "CustomMade.xml") -Value $keymapOutput
