﻿$packageName = 'flashplayeractivex'
$version = '32.0.0.192'
$majorVersion = '32'
$registry = ( Get-UninstallRegistryKey -SoftwareName "Adobe Flash Player $majorVersion ActiveX" ).DisplayVersion
$checking = ( $registry -eq $version )
$alreadyInstalled = @{$true = "Adobe Flash Player ActiveX for IE $version is already installed."; $false = "Adobe Flash Player ActiveX for IE $version is not already installed."}[ $checking ]

$allRight = $true

if ([System.Environment]::OSVersion.Version -ge '6.2') {
  $allRight = $false
  Write-Output $packageName $('Your Windows version is not ' +
    'suitable for this package. This package is only for Windows XP to Windows 7')
}

if (Get-Process iexplore -ErrorAction SilentlyContinue) {
  $allRight = $false
  Write-Output $packageName 'Internet Explorer is running. ' +
    'The installation will fail an 1603 error. ' +
    'Close Internet Explorer and reinstall this package.'
}

if ( $checking ) {
  $allRight = $false
  Write-Output $alreadyInstalled
}

if ($allRight) {
$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  url           = 'https://download.macromedia.com/pub/flashplayer/pdc/32.0.0.192/install_flash_player_32_active_x.msi'
  silentArgs    = '/quiet /norestart REMOVE_PREVIOUS=YES'
  softwareName  = 'Adobe Flash Player ActiveX'
  checksum      = '9b24059c18dd7d622d7e00b81cf20056dac3d49fdc1b02dae71a92b890417c4c'
  checksumType  = 'sha256'
}
  Install-ChocolateyPackage @packageArgs
}
