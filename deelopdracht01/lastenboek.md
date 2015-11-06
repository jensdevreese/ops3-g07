# Lastenboek Taak 1: opdracht 1

* Verantwoordelijke uitvoering: `Sébastien Pattyn`
* Verantwoordelijke testen: `Jens De Vreese`

## Deliverables

###Windows Powershell:

* Documentatie van elk boek staat op github in /Windows/Individuele Documentatie
* Cheatsheets aangemaakt van Powershell, Is een document dat continu zal aangepast worden:
```
CheatSheet Windows powershell
CLS		clear-host
CD		Set location
dir,ls		get childitem
type,cat	get-content
copry,cp	Copy-item
md/mkdir	make directory
gal		get aliases
```


###Windows Deployment:
####Scripts:

#####IP-Adress rename PC:
```
$ipaddress = "192.168.1.6"
$ipprefix = "255.255.255.0"
$ipgw = "192.168.1.1"
$ipdns = "192.168.1.6"
$wmi = Get-WmiObject win32_networkadapterconfiguration -filter "ipenabled = 'true'"
$wmi.EnableStatic($ipaddress, $ipprefix)
$wmi.SetGateways($ipgw, 1)
$wmi.SetDNSServerSearchOrder($ipdns)
#rename the computer
$newname = "ASSV1"
Rename-Computer -NewName $newname -force
#install features
$featureLogPath = "c:\logs\featurelog.txt"
New-Item $featureLogPath -ItemType file -Force
$addsTools = "RSAT-AD-Tools"
Add-WindowsFeature $addsTools
Get-WindowsFeature | Where installed >> $featureLogPath
#restart the computer
Restart-Computer
```

#####Install AD Feature:
```
$featureLogPath = "c:\logs\featurelog.txt"
start-job -Name addFeature -ScriptBlock {
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools }
Wait-Job -Name addFeature
Get-WindowsFeature | where installed >> $featureLogPath
```

#####Configure Domain
```
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
```


###Linux LAMP Stack:
- Zorg dat er gelijk wanneer in elk bestand gebruik gemaakt wordt van spaties en geen tabs. Overbodige spaties zorgen ook voor errors, dus verwijder deze ook!!
```
! heel belangrijk bij het clonen => probleem met inventory.py !
 => destroy box
 => verwijder lampstack in directory
 => $ git clone --config core.autocrlf=input https://github.com/bertvv/lampstack
 => $ cd lampstack
 => $ ./scripts/dependencies.sh
 => vagrant up
 ```
- Alle gegevens met nodige Roles
- all.yml
- Loadtestingtool: Siege
```
el7_repositories:
  - epel-release
el7_install_packages:
  - bash-completion
  - git
  - bind-utils
  - nano
  - tree
  - vim-enhanced
  - wget
el7_user_groups:
  - wheel
el7_users:
  - name: jens
    comment: Administrator
    groups:
    - wheel
    password: []
el7_admin_user: jens
el7_admin_ssh_key: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDrxsImXRCQze+W79Tjdo/MfCx8hvS+5p6WyupJfuIUr9EgUunzVITDCXA5iYZEetsNcXee7Y0nLkAB1AhO4zfq30VR5rS2MRI9twwcuCDcTdAywtEq0YGOSLoYgPCU8VaZrVXbMSm8kcvLNlL5XGkadfyrGahyL+ndE13sWeruK8tHZd0V/7a/BAkNtUQSiJaN1WYL6v1XtkOVSIH/flkPhO5FUUHSArV//e0nKUkh9vMVziiLpMNuflIOhmfZ6mN4fAVtOw4auBOcbcfxK7Ytmh0efkE0Ymy22vVEf3rmeTvZFINQN5cub2IlIWBOn0o02nKE8vPfqIiB5dVnB6QF'
el7_motd: true
```

 - Lampstack.yml
```
el7_firewalld:
  - service: http
  - permanent: true
  - state: enabled

el7_firewall_allow_services:
  - http
  - https
  - ssh

httpd_scripting: 'php'

mariadb_databases:
  - wordpress

mariadb_users:
  - name: wp_user
    password: root
    priv: 'wordpress.*:ALL'

mariadb_root_password: root

wordpress_database: wordpress
wordpress_user: wp_user
wordpress_password: root
```
-Probleem gehad met github en syncen is opgelost door volgende manier.
 - Map LAMPstack volledig verwijderen en de laatste versie van github(lampstack map) kopiëren in repository
 - zorg dat er geen Lampstack box bestaat!!
 - zorg dat alle roles uit ansible/roles verwijderd zijn
 - uitvoeren van script role_deps.sh vanuit lampstack directory
 - collectd role manueel gedownload en in ansible/roles geplaatst
 - dependencies aanpassen
 - vagrant_host voeg je de nieuwe VM toe
 - in host_vars een monitor.yml aanmaken
 - in site.yml de monitor toevoegen met nodige rollen
 - vagrant up lampstack
## Deeltaken

###Windows Powershell:

* bekijken Virtual Academy powershell Jumpstart 3.0
* lezen van volgende boeken en rapporteren naar teamleden:
    - Jens : Windows PowerShell 3.0 Step by Step. Ed Wilson
    - Jasper : Active directory management in a month of lunches
    - Mathias : Deploying and Managing Active Directory with Windows PowerShell
    - Sébastien : Windows Powershell Desired State Configuration Revealed
* Optioneel: Technet Lab: Windows Server 2012 R2: Windows Powershell Fundamentals

###Windows Deployment:

* Lezen + uitwerking boeken Netwerkbeheer Windows Server 2012
* Opdracht Deel 1 en Deel 2 van Windows Server opnieuw uitwerken
    - instellen van netwerk en computernamen
    - AD configureren
    - DHCP instellen
    - DNS instellen
    - OU's en gebruikers instellen
* 1 van de vorige opdrachten uitwerken met windows Powershell
* extra video's en tutorials hierover bekijken op virtual academy of technet labs

###Linux LAMP Stack:
* Opzetten Werkomgeving CentOS 7 door middel van Ansible en Vagrant
* Downloaden en installeren van nodige Roles
* LAMP stack met PHP-webapplicatie opzetten met behulp van Ansible:
    - aanpassingen in yml bestanden zodat alle services draaien bij starten
    - aanmaken van een DB
    - server opzetten voor monitoring
* Loadtestingtool gebruiken voor het monitoren van de lampstack.
Wij hebben gekozen om gebruik te maken van Siege. (http://sysadmindesk.com/web-server-load-testing-tool-siege/)

## Kanban-bord

week 1:
![screenschot TrelloWeek1] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week1.PNG?token=AGfNEmjxOJZa3_ToUnIQZMKEavZLBKH8ks5WPIW4wA%3D%3D)
week 2:
![screenschot week2] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week2.PNG?token=AGfNEloV_07eCswbtMF01vt9tFLZ2z83ks5WPIXGwA%3D%3D)
week 3:
![screenschot KanbanWeek3] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week3.PNG?token=AGfNEsbHukCKBcAr991A4JLxTYFp2tsCks5WPIXbwA%3D%3D)
week 4:
![screenschot TrelloWeek4] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week4.PNG?token=AGfNEl2eDQi9xkQkcp7LMRYE6-6wtRnIks5WPIXuwA%3D%3D)
week 5:
![screenshot TrelloWeek5] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week5.PNG?token=AGfNEnt1pPDrcGhj3vcVKNK0FPNO5FOfks5WPIX-wA%3D%3D)


## Tijdbesteding

| Student  | Geschat | Gerealiseerd |
| :---     |    ---: |         ---: |
| Mathias |         |              |
| Jens |         |              |
| Sébastien |      30 | 23     |
| Jasper |         |              |

(na oplevering van de taak een schermafbeelding toevoegen van rapport tijdbesteding voor deze taak)
