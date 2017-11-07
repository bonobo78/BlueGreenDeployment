function Get-BlueGreenPhysicalPath {
  [CmdletBinding()]
  param (
    [string]$WebApplication,
    [string]$PhysicalRootPath = $Script:BlueGreenConfig.PhysicalRootPath,
    [string]$VirtualRootPath = $Script:BlueGreenConfig.VirtualRootPath
  )

  Try {
    $PhysicalBluePath = "$PhysicalRootPath\$WebApplicationPath\blue"
    $PhysicalGreenPath = "$PhysicalRootPath\$WebApplicationPath\green"

    [xml]$AppXml = appcmd list app $WebApplication /config

    $LivePhysicalPath = $AppXml.application.virtualDirectory.physicalPath

    $Get-BlueGreenPhysicalPath = @{}

    switch ($LivePhysicalPath.EndsWith("blue")) {
      $True {
        $Get-BlueGreenPhysicalPath.Add("online", $PhysicalBluePath)
        $Get-BlueGreenPhysicalPath.Add("offline", $PhysicalGreenPath)
        Write-Verbose -Message ("{0}: live={1} liveIsOnBlue={2}" -f $MyInvocation.MyCommand, $PhysicalBluePath, $True)
      }
      $False {
        $Get-BlueGreenPhysicalPath.Add("online", $PhysicalGreenPath)
        $Get-BlueGreenPhysicalPath.Add("offline", $PhysicalBluePath)
        Write-Verbose -Message ("{0}: live={1} liveIsOnBlue={2}" -f $MyInvocation.MyCommand, $PhysicalGreenPath, $False)
      }
      Default {}
    }
    return $Get-BlueGreenPhysicalPath
  }
  Catch {
    Throw $_
  }
}
