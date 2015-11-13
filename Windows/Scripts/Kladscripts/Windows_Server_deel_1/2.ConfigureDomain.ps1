# Create New Forest, add Domain Controller
#Hier spreken de commando's voor zichzelf de namen van het domein worden toegekend, domainmode en forestmode worden ingesteld en DNS wordt geinstalleerd.
$domainname = "Assengraaf.nl"
$netbiosName = ASSENGRAAF
Import-Module ADDSDeployment
Install-ADDSForest -CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "Win2012" `
-DomainName $domainname `
-DomainNetbiosName $netbiosName `
-ForestMode "Win2012" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true