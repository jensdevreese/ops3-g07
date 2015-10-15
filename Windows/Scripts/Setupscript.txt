#set static IP address
$ipaddress = "192.168.1.6"
$ipprefix = "255.255.255.0"
$ipgw = "192.168.1.1"
$ipdns = "192.168.1.6"
$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
$wmi.EnableStatic($ipaddress, $ipprefix)
$wmi.SetGateways($ipgw, 1)
$wmi.SetDNSServerSearchOrder($ipdns)
#rename the computer
$newname = "DC-ConnexusV3-1"
Rename-Computer -NewName $newname -force
#install features
$featureLogPath = "c:\logs\featurelog.txt"
New-Item $featureLogPath -ItemType file -Force
$addsTools = "RSAT-AD-Tools"
Add-WindowsFeature $addsTools
Get-WindowsFeature | Where installed >> $featureLogPath
#restart the computer
Restart-Computer