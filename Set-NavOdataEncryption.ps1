function Set-NavOdataEncryption {
<#
.SYNOPSIS
This function is designed to use in the Navision Shell to setup and configure SSL for Odata on a single instance
.EXAMPLE
Set-NavOdataEncryption -ServerInstance "SampleDynamicsNAV100" -MachineName "servername.company.com" -OdataPort 7048 -CertThumbprint "a909502dd82ae41433e6f83886b00d4277a32a7b"
.PARAMETER ServerInstance
SampleDynamicsNAV100
.PARAMETER MachineName
server.local
.PARAMETER OdataPort
7048
.PARAMETER CertThumbprint
a909502dd82ae41433e6f83886b00d4277a32a7b

#>

Param(
  [string]$ServerInstance,
  [string]$MachineName,
  [string]$OdataPort,
  [string]$CertThumbprint
)


If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this!`nPlease re-run this as an Administrator!"
    Break
}

Set-NAVServerConfiguration $serverInstance -KeyName “ServicesCertificateThumbprint” -KeyValue $CertThumbprint
Set-NAVServerConfiguration $serverInstance -KeyName “PublicODataBaseUrl” -KeyValue (‘https://' +$MachineName +‘:'+$OdataPort+'/' + $serverInstance + ‘/OData/’)
Set-NAVServerConfiguration $serverInstance -KeyName “ODataServicesEnabled” -KeyValue ‘true’
Set-NAVServerConfiguration $serverInstance -KeyName “ODataServicesSSLEnabled” -KeyValue ‘true’
echo "Restarting Nav Instance"
Set-NAVServerInstance -ServerInstance $serverInstance -Restart
Set-NAVServerConfiguration $serverInstance -KeyName “ODataServicesEnabled” -KeyValue ‘false’
Set-NAVServerConfiguration $serverInstance -KeyName “ODataServicesSSLEnabled” -KeyValue ‘false’
echo "Restarting Nav Instance with SSL Disabled - Used to ensure new cert is being used - Due to bug in NAV"
Set-NAVServerInstance -ServerInstance $serverInstance -Restart
Set-NAVServerConfiguration $serverInstance -KeyName “ODataServicesEnabled” -KeyValue ‘true’
Set-NAVServerConfiguration $serverInstance -KeyName “ODataServicesSSLEnabled” -KeyValue ‘true’
echo "Restarting Nav Instance - This will re-enable SSL"
Set-NAVServerInstance -ServerInstance $serverInstance -Restart
echo "Complete"
}
