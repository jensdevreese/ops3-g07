#############################
# Change Name of the Server #
#############################
Rename-Computer -NewName "AsRtr" -Force

#########################
# Set static ip address #
#########################
Rename-NetAdapter -Name "Ethernet" -NewName InternetConnectie
Rename-NetAdapter -Name "Ethernet 2" -NewName Assengraaf
Rename-NetAdapter -Name "Ethernet 3" -NewName Breed

Disable-NetAdapterBinding -InterfaceAlias Assengraaf -ComponentID ms_tcpip6
Disable-NetAdapterBinding -InterfaceAlias Breed -ComponentID ms_tcpip6

Get-NetIPAddress -InterfaceAlias Assengraaf | Remove-NetIPAddress
Get-NetIPAddress -InterfaceAlias Breed | Remove-NetIPAddress

Set-NetIPInterface -InterfaceAlias Assengraaf -Dhcp Disabled
New-NetIPAddress -InterfaceAlias Assengraaf -IPAddress 192.168.210.1 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias Assengraaf -ServerAddresses 192.168.210.11

Set-NetIPInterface -InterfaceAlias Breed -Dhcp Disabled
New-NetIPAddress -InterfaceAlias Breed -IPAddress 192.168.220.1 -PrefixLength 24
Set-DnsClientServerAddress -InterfaceAlias Breed -ServerAddresses 192.168.210.11

############################
# Installeer remote access #
############################

Install-WindowsFeature -Name Routing -IncludeManagementTools


Set-Service RemoteAccess -startuptype "auto"
Start-Service RemoteAccess

Install-RemoteAccess -VpnType Vpn
 
$ExternalInterface="Assengraaf"
$InternalInterface="InternetConnectie"
 
netsh routing ip nat install
netsh routing ip nat add interface $ExternalInterface private
netsh routing ip nat set interface $ExternalInterface mode=full
netsh routing ip nat add interface $InternalInterface private



###########
# Restart #
###########
Restart-Computer