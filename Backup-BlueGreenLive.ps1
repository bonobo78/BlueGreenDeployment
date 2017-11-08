function Backup-BlueGreenLive {
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [string]$WebsiteName,
    [parameter(Mandatory = $True)]
    [string]$WebApplicationPath = "",
    [string]$PhysicalBackupPath = $Script:BlueGreenConfig.PhysicalBackupPath
  )

  $WebApplication = "$WebsiteName/$WebApplicationPath"
  Write-Host "$($MyInvocation.MyCommand): starting for '$WebApplication'"

  $PhysicalApplicationPath = Get-BlueGreenPhysicalPath -WebApplication $WebApplication

  $CurrentDateFormatted = Get-Date -Format yyyyMMddHHmmss
  $BackupPath = "$PhysicalBackupPath\$WebApplication\$CurrentDateFormatted"
  $SourcePath = $PhysicalApplicationPath.online

  Write-Verbose -Message ("{0}: {1} to {2}" -f $MyInvocation.MyCommand, $FullVirtualPath, $BackupPath)

  New-Item -Path $BackupPath -Type Directory -Force -ErrorAction Stop | Out-Null
  Copy-Item $SourcePath\* $BackupPath -Recurse -Force -ErrorAction Stop

  Write-Verbose -Message ("{0}: complete for {1}" -f $MyInvocation.MyCommand, $WebApplication)
}
