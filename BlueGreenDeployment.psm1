#Get public and private function definition files.
    $Public  = Get-ChildItem $PSScriptRoot\*.ps1 -ErrorAction SilentlyContinue
    $Private = Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error "Failed to import function $($import.fullname): $_"
        }
    }

#Aliasing appcmd tool
    New-Alias -Name appcmd -Value "C:\Windows\System32\inetsrv\appcmd.exe" -Description "quick appcmd" -Option ReadOnly

#Create / Read config
    #handle PS2
    if(-not $PSScriptRoot)
    {
        $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
    }

    if(-not (Test-Path -Path "$PSScriptRoot\BlueGreenDeployment.xml" -ErrorAction SilentlyContinue))
    {
        Try
        {
            Write-Warning "Did not find config file $PSScriptRoot\BlueGreenDeployment.xml, attempting to create"
            Set-BlueGreenConfig
        }
        Catch
        {
            Write-Warning "Failed to create config file $PSScriptRoot\BlueGreenDeployment.xml: $_"
        }
    }

#Initialize the config variable.  I know, I know...
    Try
    {
        #Import the config
        $BlueGreenConfig = $null
        $BlueGreenConfig = Get-BlueGreenConfig -Source BlueGreenDeployment.xml -ErrorAction Stop
    }
    Catch
    {
        Write-Warning "Error importing BlueGreenDeployment config: $_"
    }

    #$VirtualRootPath = "IIS:\Sites"
    #$PhysicalRootPath = "c:\inetpub\wwwroot"
    #$PhysicalBackupPath = "c:\inetpub_backup\wwwroot"

# Modules
Export-ModuleMember -Function $($Public | Select -ExpandProperty BaseName) -Alias *
