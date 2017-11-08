function Switch-BlueGreen {
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [string] $WebsiteName,
    [parameter(Mandatory = $True)]
    [string] $WebApplicationPath = "",
    [string]$VirtualRootPath = $Script:BlueGreenConfig.VirtualRootPath
  )

  $WebApplication = "$WebsiteName/$WebApplicationPath"

  $liveSite = "$VirtualRootPath\$WebApplication"
  $PhysicalApplicationPath = Get-BlueGreenPhysicalPath -WebApplication $WebApplication

  $DestinationPath = $PhysicalApplicationPath.offline

  "{0}: starting for {1}" -f $MyInvocation.MyCommand, $WebApplication

  $retVal = Set-BlueGreenHAMaintenance -action "offline" -WebsiteName $WebsiteName -WebApplicationPath $WebApplicationPath
  $retVal = Stop-AppPool -WebsiteName $WebsiteName -WebApplicationPath $WebApplicationPath
  Write-Verbose -Message ("{0}: Changing PhysicalPath to {1}" -f $MyInvocation.MyCommand, $DestinationPath)

  Set-ItemProperty $liveSite -Name PhysicalPath -Value $DestinationPath -ErrorAction Stop

  $retVal = Start-AppPool -WebsiteName $WebsiteName -WebApplicationPath $WebApplicationPath

  Write-Host "$($MyInvocation.MyCommand): complete for '$WebApplication'"
}
