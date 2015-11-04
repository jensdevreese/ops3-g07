#####################
# Install DHCP role #
#####################
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Add-DhcpServerSecurityGroup
netsh dhcp add securitygroups
Restart-service dhcpserver

##################
# Configure DHCP #
##################
Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias “Ethernet 2”
Add-DhcpServerInDC -DnsName “AsSv1.Assengraaf.nl”
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2
Add-DhcpServerv4Scope -Name "Friendly Name of Scope" -StartRange 192.168.10.100 -EndRange 192.168.10.150 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -OptionId 6 -value 192.168.10.5 #DNS
Set-DhcpServerv4OptionValue -OptionId 3 -value 192.168.10.5 #Default Gateway

#############################
# Add forwarders DNS Server #
#############################
Add-DnsServerForwarder -IPAddress 8.8.8.8
Add-DnsServerForwarder -IPAddress 8.8.4.4