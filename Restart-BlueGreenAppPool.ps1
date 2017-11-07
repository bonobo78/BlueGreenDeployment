function Restart-BlueGreenAppPool {
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [string] $WebsiteName,
    [parameter(Mandatory = $True)]
    [string] $WebApplicationPath = "/"
  )

  $retVal = Stop-AppPool -WebsiteName $WebsiteName -WebApplicationPath $WebApplicationPath
  $retVal = Start-AppPool -WebsiteName $WebsiteName -WebApplicationPath $WebApplicationPath
}
