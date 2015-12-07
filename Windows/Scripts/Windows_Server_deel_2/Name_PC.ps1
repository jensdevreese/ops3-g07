#############################
# Change Name of the Server ##############################
Rename-Computer -NewName "AsRtR" -Force

#########################
# Set static ip address #
#########################
Set-NetIPInterface -InterfaceAlias "Ethernet 2" -Dhcp Disabled
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 192.168.210.0 -PrefixLength 24 -DefaultGateway 192.168.10.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses 192.168.210.11

###########
# Restart #
###########
Restart-Computer