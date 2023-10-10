$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://zoom.us/download/vdi/5.16.0.24280/ZoomInstallerVDI.msi'
$url64      = "https://zoom.us/download/vdi/5.16.0.24280/ZoomInstallerVDI.msi?archType=x64"

$silentArgs = '/quiet /qn /norestart'

$PackageParameters = Get-PackageParameters

if ($PackageParameters['DisableRestartManager']) { $silentArgs += " MSIRestartManagerControl=Disable" }
if ($PackageParameters['NoAutoUpdate']) { $silentArgs += " ZoomAutoUpdate=0" }
else { $silentArgs += " ZoomAutoUpdate=1" }
if ($PackageParameters['NoDesktopShortcut']) { $silentArgs += " zNoDesktopShortCut=True" }
if ($PackageParameters['NoInstallIfRunning']) { 
  if (Get-Process zoom -ea 0) {
    Write-Warning "Exiting installation because Zoom is running and /NoInstallIfRunning was passed."
    exit 1
  }
}
if ($PackageParameters['SilentStart']) { $silentArgs += " zSilentStart=True" }
if ($PackageParameters['SSOHost']) { $silentArgs += " zSSOHost=$(pp['SSOHost'])" }
if ($PackageParameters['64']){
  $url = $url64

  $checksum = '0264BF5CF237E1C08961AE40C588C6011ADB30DB654DEA55F3215832B8F39FBD'
} else {
  $checksum = '0B3618BD29752A55325C4E73606A7F119164A0919BCE8829316D767A210A3024'
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI' #only one of these: exe, msi, msu
  url           = $url
  #file         = $fileLocation

  softwareName  = 'Zoom-VDI*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
  checksum      = $checksum
  checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512

  # MSI
  silentArgs    = $silentArgs
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage
