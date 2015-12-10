
######################################
# Change static ip address & gateway #
######################################
Set-NetIPInterface -InterfaceAlias "Ethernet 2" -Dhcp Disabled
Remove-NetRoute -InterfaceAlias "Ethernet 2" -NextHop 192.168.10.1
Get-NetIPAddress –IPAddress 192.168.10.5 | Remove-NetIPAddress
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 192.168.210.11 -PrefixLength 24 -DefaultGateway 192.168.210.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses 127.0.0.1

#################
# dhcp v4 scope #
#################

Get-DhcpServerv4Scope | Remove-DhcpServerv4Scope -Force
Add-DhcpServerv4Scope -Name "Nieuw Assengraaf" -StartRange 192.168.210.100 -EndRange 192.168.210.150 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -OptionId 3 -Value 192.168.210.1
Set-DhcpServerv4OptionValue -OptionId 6 -Value 192.168.210.11

###########
# Restart #
###########
Restart-Computer