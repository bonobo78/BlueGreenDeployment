Function Get-BlueGreenConfig {
    <#
    .SYNOPSIS
        Get BlueGreen module configuration

    .DESCRIPTION
        Get BlueGreen module configuration

    .PARAMETER Source
        Config source:
        BlueGreenConfig to view module variable
        BlueGreenDeployment.xml to view BlueGreenDeployment.xml

    .FUNCTIONALITY
        RabbitMq
    #>
    [cmdletbinding()]
    param(
        [ValidateSet('BlueGreenConfig','BlueGreenDeployment.xml')]
        [string]$Source = "BlueGreenConfig"
    )

    #handle PS2
    if(-not $PSScriptRoot)
    {
        $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
    }

    if($Source -eq "BlueGreenConfig")
    {
        $Script:BlueGreenConfig
    }
    else
    {
        Import-Clixml -Path "$PSScriptRoot\BlueGreenDeployment.xml"
    }
}
