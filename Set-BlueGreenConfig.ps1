Function Set-BlueGreenConfig {
    <#
    .SYNOPSIS
        Set PSRabbitMq module configuration.

    .DESCRIPTION
        Set PSRabbitMq module configuration, and module $RabbitMqConfig variable.

        This data is used as the default for most commands.

    .PARAMETER ComputerName
        Specify a ComputerName to use

    .Example
        Set-RabbitMqConfig -ComputerName "rabbitmq.contoso.com"

    .FUNCTIONALITY
        RabbitMq
    #>
    [cmdletbinding()]
    param(
        [string]$VirtualRootPath = "IIS:\Sites",
        [string]$PhysicalRootPath = "C$\inetpub\wwwroot",
        [string]$PhysicalBackupPath = "C$\inetpub_backup\wwwroot"
    )

    #handle PS2
    if(-not $PSScriptRoot) {
        $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
    }

    $Script:BlueGreenConfig = [pscustomobject]@{
      VirtualRootPath = $VirtualRootPath
      PhysicalRootPath = $PhysicalRootPath
      PhysicalBackupPath = $PhysicalBackupPath
    }

    $Script:BlueGreenConfig | Export-Clixml -Path "$PSScriptRoot\BlueGreenDeployment.xml" -force
}
