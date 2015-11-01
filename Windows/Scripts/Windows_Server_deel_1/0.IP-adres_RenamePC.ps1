#set static IP address variabele
$ipaddress = "192.168.1.6"
#Subnetmask varibele
$ipprefix = "255.255.255.0"
#Default gateway variabele
$ipgw = "192.168.1.1"
#DNS instellen
$ipdns = "192.168.1.6"
#Netwerkadapter ophalen
$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
#Statisch ip ctiveren en ip-adres instellen + subnetmask
$wmi.EnableStatic($ipaddress, $ipprefix)
#defaultgateway instellen
$wmi.SetGateways($ipgw, 1)
#DNS instellen
$wmi.SetDNSServerSearchOrder($ipdns)
#Computer hernoemen
$newname = "ASSV1"
Rename-Computer -NewName $newname -force
#installeren features
$featureLogPath = "c:\logs\featurelog.txt"
New-Item $featureLogPath -ItemType file -Force
#Bijhorende tols invoegen
$addsTools = "RSAT-AD-Tools"
Add-WindowsFeature $addsTools
Get-WindowsFeature | Where installed >> $featureLogPath
#restart de computer
Restart-Computer