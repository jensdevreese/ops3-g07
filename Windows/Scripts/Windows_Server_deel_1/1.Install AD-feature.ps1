#Install AD DS, DNS and GPMC
$featureLogPath = "c:\logs\featurelog.txt"
start-job -Name addFeature -ScriptBlock {
#De features installeren van de AD , DNS en group policy management
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools }
Wait-Job -Name addFeature
#Specifiek de geinstalleerde features krijgen die geinstalleerd zijn en die opslagen in featurelog.txt
Get-WindowsFeature | where installed >> $featureLogPath