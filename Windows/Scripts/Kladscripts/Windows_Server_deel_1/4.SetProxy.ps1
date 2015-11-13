  4_Set_Proxy.ps1 
? #################################
# Install proxy server Services #
#################################
Install-WindowsFeature -Name Routing -IncludeManagementTools
################################
# Import proxy server settings #
################################
Set-Service RemoteAccess -startuptype "auto"
Start-Service RemoteAccess
netsh -f RAS.txt
Restart-Service RemoteAccess
netsh -f RAS.txt