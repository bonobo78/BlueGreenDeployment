function Publish-BlueGreenOffline {
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [string] $Source,
    [parameter(Mandatory = $True)]
    [string] $WebsiteName,
    [parameter(Mandatory = $True)]
    [string] $WebApplicationPath = "",
    [parameter(Mandatory = $True)]
    [string] $ComputerName = "$env:COMPUTERNAME"
    )

  $WebApplication = "$WebsiteName/$WebApplicationPath"
  Write-Host "$($MyInvocation.MyCommand): starting for '$WebApplication'"

  $PhysicalApplicationPath = Get-BlueGreenPhysicalPath -WebApplication $WebApplication

  $SourcePath = Resolve-Path $Source
  $DestinationPath = $PhysicalApplicationPath.offline

  Write-Verbose ("{0}: Source: {1}" -f $MyInvocation.MyCommand, $SourcePath)
  Write-Verbose ("{0}: Destination: {1}" -f $MyInvocation.MyCommand, $DestinationPath)

  if(Test-Path $DestinationPath){
    Remove-Item $DestinationPath -Recurse -Force -ErrorAction Stop
  }

  New-Item $DestinationPath -Type Directory -ErrorAction Stop | Out-Null

  # Création du IsUpAndRunning pour Aloha
  #New-Item $DestinationPath\IsUpAndRunning.aspx -Type File -ErrorAction Stop | Out-Null
  #Set-Content -Path $DestinationPath\IsUpAndRunning.aspx -Value $False

  Copy-Item $SourcePath\* $DestinationPath -Recurse -Force -ErrorAction Stop
  #RewriteLogFileLocation -PhysicalPath $DestinationPath -isStaging $true

  Write-Host "$($MyInvocation.MyCommand): complete for '$WebApplication'"
}
