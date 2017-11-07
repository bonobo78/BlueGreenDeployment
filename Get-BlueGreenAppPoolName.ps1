function Get-BlueGreenAppPoolName {
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [string] $WebApplication
  )
  Try {
    [xml]$AppXml = appcmd list app $WebApplication /config
  }
  Catch {
    Throw $_
  }
  return $AppXml.application.applicationPool
}
