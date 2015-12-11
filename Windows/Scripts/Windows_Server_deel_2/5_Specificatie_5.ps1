#############
# static IP #
#############

Set-NetIPInterface -InterfaceAlias "Ethernet" -Dhcp Disabled
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.220.10 -PrefixLength 24 -DefaultGateway 192.168.220.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.220.1

###############
# Join Domain #
###############

$domain = "Assengraaf.nl"
$password = "Test123" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\Administrator" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential

###########
# Restart #
###########
Restart-Computer