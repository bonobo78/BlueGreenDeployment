function Stop-BlueGreenAppPool {
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [string] $WebApplication
  )

  $ApplicationPoolName = Get-BlueGreenAppPoolName -WebApplication $WebApplication

  Try {
    $retVal = appcmd stop apppool $ApplicationPoolName
    Write-Verbose -Message ("{0}: {1}" -f $MyInvocation.MyCommand, $retVal)
  }
  Catch {
    Throw $_
  }
}
