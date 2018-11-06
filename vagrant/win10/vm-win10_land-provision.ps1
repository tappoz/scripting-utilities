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

write-host "Install Microsoft Office 365... "
# This gives Microsoft Excel to be used with libraries e.g. `xlwings`
# to create or inject data into reports
# TODO You need to *MANUALLY* sign in to get a valid license to use Microsoft Office
cinst -y office365proplus
write-host "END Install Microsoft Office 365... "

write-host "Install miniconda3 version 4.5.11... "
# Cf. the docs: https://conda.io/docs/user-guide/install/windows.html
# (also https://chocolatey.org/packages/miniconda3)
# TODO make sure you sign out then sign in again of the running GUI to allow the PATH settings to become active
# i.e. being able to call `python` and `conda` from the command line
cinst -y  miniconda3 --version 4.5.11 --params="'/InstallationType=AllUsers /AddToPath=1 /RegisterPython=1 /D=C:\tools\miniconda3'"
write-host "END Install miniconda3 version 4.5.11!"
