Function Set-BlueGreenHAMaintenance {
  [CmdletBinding()]
  param (
    [parameter(Mandatory = $True)]
    [string]$WebsiteName,
    [parameter(Mandatory = $True)]
    [string]$WebApplicationPath = "",
    [parameter(Mandatory = $True)]
    [ValidateSet("online","offline")]
    [string]$action = "offline",
    [string]$HAserver
  )

  $WebApplication = "$WebsiteName/$WebApplicationPath"

  $PhysicalApplicationPath = Get-BlueGreenPhysicalPath -WebApplication $WebApplication
  $OnlinePath = $PhysicalApplicationPath.online

  switch ($action)
  {
    "offline" {
      # Suppression du IsUpAndRunning pour Soft-stop Aloha
      Write-Verbose -Message ("{0}: Deleting {1}\IsUpAndRunning.aspx to disable server on Aloha" -f $MyInvocation.MyCommand, $OnlinePath)

      if(Test-Path $OnlinePath\IsUpAndRunning.aspx){
        Remove-Item -Path $OnlinePath\IsUpAndRunning.aspx | Out-Null
      }

      Write-Verbose -Message ("{0}: polling Aloha to check for maintenance mode to take effect" -f $MyInvocation.MyCommand)

      if(WaitHaServerDown $HAserver){
        $Set-BlueGreenHAMaintenance = $True
        Write-Verbose -Message "$($MyInvocation.MyCommand): Server $HAserver has gone offline."
      } else {
        $Set-BlueGreenHAMaintenance = $False
        Write-Verbose -Message "$($MyInvocation.MyCommand): Server $HAserver is still online."
      }
    }
    "online" {
      # Création du IsUpAndRunning pour balancing Aloha
      Write-Verbose -Message ("{0}: Creating {1}\IsUpAndRunning.aspx to enable server on Aloha" -f $MyInvocation.MyCommand, $OnlinePath)
      Set-Content -Path $OnlinePath\IsUpAndRunning.aspx -Value $True | Out-Null

      Write-Verbose -Message ("{0}: polling Aloha to check for server activation" -f $MyInvocation.MyCommand)

      if(WaitHaServerUp $HAserver){
        $Set-BlueGreenHAMaintenance = $True
        Write-Verbose -Message "$($MyInvocation.MyCommand): Server $HAserver has gone online."
      } else {
        $Set-BlueGreenHAMaintenance = $False
        Write-Verbose -Message "$($MyInvocation.MyCommand): Server $HAserver is still offline."
      }
    }
    Default {}
  }
}
