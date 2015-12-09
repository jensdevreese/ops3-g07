Set-ExecutionPolicy -ExecutionPolicy Bypass -Force

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