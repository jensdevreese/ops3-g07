###################################
# Disable Routing & remote Access #
###################################
Stop-Service RemoteAccess
Set-Service RemoteAccess -StartupType Disabled
Uninstall-WindowsFeature RemoteAccess
Uninstall-WindowsFeature Routing
Uninstall-WindowsFeature RSAT-RemoteAccess

# turn off internet NIC
Get-NetAdapter -Name Ethernet | Disable-NetAdapter
Rename-NetAdapter -Name Ethernet -NewName NietInGebruik


###########
# Restart #
###########
Restart-Computer


