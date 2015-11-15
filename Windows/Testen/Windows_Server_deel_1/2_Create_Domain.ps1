###########################
# Install domain services #
###########################
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
############################################
# Create New Forest, add Domain Controller #
############################################
Import-Module ADDSDeployment
$domainName = "Assengraaf.nl"
$netbiosName = "ASSENGRAAF"
$forestMode = "Win2012R2"
$domainMode = "Win2012R2"
Omschrijving taak
Deliverables
Gemaakte scripts deel 1
16­12­2014 g_connexus/dossier.md at b2dc92fb686bb4f610c8e65c7a16199f174295f1 · HoGentTIN/g_connexus
https://github.com/HoGentTIN/g_connexus/blob/b2dc92fb686bb4f610c8e65c7a16199f174295f1/dossier.md 22/28
$databasePath = "C:\Windows\NTDS"
$logPath = "C:\Windows\NTDS"
$sysVolPath = "C:\Windows\SYSVOL"
Install-ADDSForest `
-InstallDns `
-DatabasePath $databasePath `
-DomainMode $domainMode `
-DomainName $domainName `
-DomainNetbiosName $netbiosName `
-ForestMode $forestMode `
-LogPath $logPath `
-SysvolPath $sysVolPath `
-Force