﻿$ErrorActionPreference = 'Stop'

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$checksum = '8b8cf709f10085f7cec31533ebe3913407eaa01b16d8ec6299571af808478509'
$checksum64 = 'ad9aa21063c138a6fdfe65e5b5ebe5e85594ecac51f0384e1090f831607170f3'

$url = 'https://cdn.zoom.us/prod/5.16.2.22807/ZoomInstallerFull.msi'
$url64 = 'https://cdn.zoom.us/prod/5.16.2.22807/x64/ZoomInstallerFull.msi'

$silentArgs = '/quiet /qn /norestart'

$PackageParameters = Get-PackageParameters

if ($PackageParameters['DisableRestartManager']) { $silentArgs += " MSIRestartManagerControl=Disable" }
if ($PackageParameters['NoAutoUpdate']) { $silentArgs += " ZoomAutoUpdate=False" }
else { $silentArgs += " ZoomAutoUpdate=True" }
if ($PackageParameters['NoDesktopShortcut']) { $silentArgs += " zNoDesktopShortCut=True" }
if ($PackageParameters['NoInstallIfRunning']) { 
  if (Get-Process zoom -ea 0) {
    Write-Warning "Exiting installation because Zoom is running and /NoInstallIfRunning was passed."
    exit 1
  }
}
if ($PackageParameters['SilentStart']) { $silentArgs += " zSilentStart=True" }
if ($PackageParameters['SSOHost']) { $silentArgs += " zSSOHost=$(pp['SSOHost'])" }

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  unzipLocation  = $toolsDir
  fileType       = 'msi'
  url            = $url
  url64          = $url64
  silentArgs     = $silentArgs
  validExitCodes = @(0, 3010)
  softwareName   = 'zoom*'
  checksum       = $checksum
  checksum64     = $checksum64
  checksumType   = 'sha256'
  checksumType64 = 'sha256'
}

Install-ChocolateyPackage @packageArgs
