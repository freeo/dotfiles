#. (Resolve-Path "$env:LOCALAPPDATA\GitHub\shell.ps1")
# Load posh-git example profile
#. 'C:\Users\Ich\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

$env:path += ";" + (Get-Item "Env:ProgramFiles(x86)").Value + "\Git\bin"

$env:is_powershell = 1

# & 'D:\Progs\clink\0.4.9\clink_x64.exe' inject powershell.exe 

# Load posh-git example profile
# . 'C:\Users\Freeo\Documents\WindowsPowerShell\Modules\posh-git\profile.example.ps1'

function removesh
{
    <#
    .Synopsis
    Removes sh.exe from $env:path.
    #>
    if (& which.exe sh.exe) {
        $env:PATH=$env:PATH -replace ";C:\\Program Files `\(x86`\)\\Git\\bin", ""
        echo "Remove sh.exe from `$env:path"
    }
}

# My Aliases
function cd1up{Set-Location ..}
function cd2up{Set-Location ..\..}
function cd3up{Set-Location ..\..\..}
function cd4up{Set-Location ..\..\..\..}
Set-Alias cd.. cd1up
Set-Alias cd... cd2up
Set-Alias cd.... cd3up
Set-Alias cd..... cd4up

# Set-Alias geeknote C:\Python27\Scripts\geeknote.exe

# writing help:
# begin with multiline comment
# use special help tags (synopsis is displayed in every help call)
#
# getting help:
# Get-Help myfunction (-parameter)
# parameters:
# -detailed -full


function gcaladd($msg){
    <#
    .Synopsis
    Usage:
    google calendar add "calender entry (msg) 2014-12-5"
    December is a special case. This works for all months except December:
    google calendar add "calender entry (msg) November 5"
    Alias:
    gcal = google calendar add
        gcal "calender entry (msg) 2014-12-5"

    .Notes
    Non working examples:
    gcal calender entry (msg) 2014-12-5
    (missing quotes)
    gcal "calender entry (msg) 2014-12-05"
    (05 won't be parsed)
#>
    E:\google_cl\google.exe calendar add $msg}
set-alias gcal gcaladd

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme kalisi

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function Get-GitStatus { & git status $args }
New-Alias -Name gs -Value Get-GitStatus

Import-Module PSReadLine

Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Cursor

# https://stackoverflow.com/questions/39547321/rebind-escape-in-psreadline-for-vi-mode
# This may cause problems with pasting 'j', however.
Set-PSReadLineKeyHandler -Chord 'j' -ScriptBlock {
  if ([Microsoft.PowerShell.PSConsoleReadLine]::InViInsertMode()) {
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($key.Character -eq 'k') {
      [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
    }
    else {
      [Microsoft.Powershell.PSConsoleReadLine]::Insert('j')
      [Microsoft.Powershell.PSConsoleReadLine]::Insert($key.Character)
    }
  }
}


function gitmoji-commit { & gitmoji -c }
New-Alias -Name gmc -Value gitmoji-commit

function ZtoJ { & z $args }
New-Alias -Name j -Value ZtoJ

# remap of RightArrow doesn't work yet, beta.
# https://github.com/PowerShell/PSReadLine/issues/687
# Set-PSReadLineKeyHandler -Key "Shift+Tab" -Function AcceptSuggestion

echo "Loaded my profile"

