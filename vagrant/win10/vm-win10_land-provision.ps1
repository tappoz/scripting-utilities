# Additonal packages can be found at https://chocolatey.org/packages
# https://github.com/PioneerCode/pioneer-windows-development-environment/blob/master/scripts/install-choco.ps1

Write-host "Choco Started At: $((Get-Date).ToString())"

$ChocoInstallPath = "$($env:SystemDrive)\ProgramData\Chocolatey\bin"
if (!(Test-Path $ChocoInstallPath)) {
    write-host "Install Chocolatey..."
    Invoke-Expression ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1')) | out-null
    write-host "END Installing Chocolatey!"
} else {
    write-host "Upgrade Chocolatey..."
    choco upgrade chocolatey
    write-host "END Upgrade Chocolatey!"
}

chocolatey feature enable -n=allowGlobalConfirmation

write-host "Install Firefox... "
cinst -y  firefox | Out-Null
write-host "END Install Firefox!"

write-host "Install cygwin... "
cinst -y  cygwin | Out-Null
write-host "END Install cygwin!"

# For all options you can use, call `cyg-get -help`
write-host "Install cyg-get... "
cinst -y  cyg-get | Out-Null
write-host "END Install cyg-get!"

write-host "Install git... "
cyg-get.bat git
write-host "END Install git!"

# https://chocolatey.org/packages/nodejs/6.5.0
# Azure Functions at the moment are on version 6.5.0
write-host "Install nodejs version 6.5.0... "
cinst -y  nodejs --version 6.5.0 | Out-Null
write-host "END Install nodejs version 6.5.0!"

write-host "Install miniconda3 version 4.5.1... "
cinst -y  miniconda3 --version 4.5.1 # --force # /D=%UserProfile%\Miniconda3 /AddToPath=1
write-host "END Install miniconda3 version 4.5.1!"

# TODO: perhaps a radical thing like: https://stackoverflow.com/a/50596035/1264920
write-host "Configure miniconda3 for cygwin..."
# $oldSysPath = (Get-Itemproperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path).Path
# $newSysPath = $oldSysPath + ";C:\tools\miniconda3"
# Set-ItemProperty -path 'hklm:\system\currentcontrolset\control\session manager\environment' -Name Path -Value $newSysPath

# alternative way to set the PATH... (not sure what Powershell is doing with this PATH thing...)
$env:Path += ";C:\tools\miniconda3"
write-host "END Configure miniconda3 for cygwin..."
