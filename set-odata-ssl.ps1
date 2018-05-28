###########################
# Created 11/30/17        #
# Last Modified 05/22/18  #
# Version NAV 2015 & 2017 #
# Created by: FrankieM    #
###########################

# This is designed to set a thumbprint, set the Odata URL, Enable Odata, and enable SSL for Odata. Then restart the instance.
# Be sure to set the odataPort, it is different per instance.
# To see the changes in the Nav Administrative 'console' you'll need to close and re-open.


$serverInstance = "NameofInstance"
$PublicMachineName = "servername.company.com"
$odataPort = "7048"
$certThumbprint

Set-NAVServerConfiguration $serverInstance -KeyName “ServicesCertificateThumbprint” -KeyValue $certThumbprint
Set-NAVServerConfiguration $serverInstance -KeyName “PublicODataBaseUrl” -KeyValue (‘https://' +$PublicMachineName +‘:'+$odataPort+'/' + $serverInstance + ‘/OData/’)
Set-NAVServerConfiguration $serverInstance -KeyName “ODataServicesEnabled” -KeyValue ‘true’
Set-NAVServerConfiguration $serverInstance -KeyName “ODataServicesSSLEnabled” -KeyValue ‘true’
Set-NAVServerInstance -ServerInstance $serverInstance -Restart
