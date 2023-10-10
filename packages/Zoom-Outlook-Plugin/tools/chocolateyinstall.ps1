$ErrorActionPreference = 'Stop' # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://zoom.us/client/5.15.5.926/ZoomOutlookPluginSetup.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI' #only one of these: exe, msi, msu
  url           = $url

  softwareName  = 'Zoom-Outlook-Plugin*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique

  checksum      = '4b1583351ceb8944356310345f1c3b6bd431099e2b61acc389c31e30b64f3ac3'
  checksumType  = 'sha256' #default is md5, can also be sha1, sha256 or sha512

  # MSI
  silentArgs    = "/qn /norestart /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs # https://docs.chocolatey.org/en-us/create/functions/install-chocolateypackage