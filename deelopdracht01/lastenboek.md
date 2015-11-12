# Lastenboek Taak 1: opdracht 1

* Verantwoordelijke uitvoering: `Sébastien Pattyn`
* Verantwoordelijke testen: `Jens De Vreese`

## Deliverables

###Windows Powershell:

* Documentatie van elk boek staat op github in /Windows/Individuele Documentatie
* Cheatsheets aangemaakt van Powershell, Is een document dat continu zal aangepast worden:

####Cheatsheets
#####basic commands:
```
cls -> clear-host
cd -> set-location
dir, ls -> get-childitem
type, cat -> get-content
copy, cp -> copy - item
get-alias ->>>
gal >
gal g* -> all get commands
man -> help
update-help -Force
save help
get-help
* -> wildcard
get-help get-service (-Detailed) (-full) (-online) (-showwindow)
```
#####advanced (parameters):
```
Get-Service -Name b*, c*
Get-Service -Name bits, bfe -> gsv bits,bfe
Get-EventLog -LogName system -Newest 3 -EntryType error
Get-Service | Export-Csv C:\Users\Nick\Desktop\service.csv
notepad C:\Users\Nick\Desktop\service.csv

bv: malware bestrijden
get-process | export-climxml -Path c:\good.xml
notepad
calc
compare-Object -ReferenceObject (import-climxl c:\good.xml) -Difference (get-process) -propery name
Get-Context c:\test.txt
get-service | converto-html -property name,status | out-file c:\test.html
get-service | converto-html -property name,status | kan ook verder mee werken
export = convert + export

get-service | stop-service -whatif
get-service | stop-service -confirm

V2 problems
cd\
get-Module -> currently loaded modules
get-adcomputer - filer *
get-Module -> automaticly loaded module activeDirectory
```
#####greater then, select property's, info about property's, extra property's, sorting:
```
Get-Process |  where handles -gt 999
Get-Process |  where handles -gt 999 | sort handles
Get-Service -name BITS | get-member -> gives info like property's or methods
get-service | select -propery name,status  -> just select certain property's
Get-ChildItem | select -Property name, length | sort length (-Descending)
Get-EventLog -LogName System -Newest 5 | select -Property EventID, TimeWritten, Message

get a file like romeo and julia

$x = [xml](cat .\romeoandjulia.xml)

cast to xml, work with xml files

$x.play -> overview of xml
$x.play.act -> overview of acts
$x.play.act[0].scene[0].speech
$x.play.act.scene.speech | group speaker | sort count

filters ( before sort)

get-service | where {$_.status -eq "Running" -and $_.name -like "b*"}
get-service | where {$PSitem.status -eq "Running"}
each service is assigned in $_ or PSitem

```
#####pipelining inputs like serviceController in gm can be used in stop-process
```
get-service | gm vs get-help get-service -full
bv get-process calc | dir

Get-AdComputer -filter * | select -Property name, @{name='computername'; expression={$PSitem.name}}
Get-AdComputer -filter * | select -Property name, @{n='computername'; e={$PSitem.name}}

make existing "name" change to computername so it accepts 
soooooo...

Get-AdComputer -filter * | select -Property @{n='computername'; e={$PSitem.name}} | get-service -name bits

CAST adcomputer to a string

Get-adcomputer -filter * | select -ExpandProperty name
Get-WmiObject -class win32_bios -computerName (get-adcomputer -filter * | select -ExpandProperty name)
Get-WmiObject -class win32_bios -computerName (get-adcomputer -filter * ).name
Get-ADcomputer -filter * | get-wmiobject win32_bios -computerName {$_.Name}
```
#####Remoting
```
enter-PSSession -ComputerName dc
invoke-command -computerName cd,s1,s2 {get-eventlog -logname system -new 3}
install-windowsFeature WindowsPowerShellwebAcces
install -PsawaWebapplication -UsetestCertificate
add -PswaAuthorizationRule * * *
everyone can do anything
start iexplore https://pwa/pswa -> put in credentials and dc
Get-Volume
icm dc,s1,s2 {Get-Volume} | sort sizeremaining
```

* EindDocument komt in ops3-g07/Windows/Uitwerking, als alle boeken uit zijn


###Windows Deployment:
####Scripts:
##### 0_Create_Disk:
Opmerking: Als je in virtualbox werkt, moet je zorgen dat er 2 harde schijven aanwezig zijn in de box.
########################
# Initialize the disks #
########################
Initialize-Disk 1 -PartitionStyle MBR
Initialize-Disk 2 -PartitionStyle MBR

#####################
# Create partitions #
#####################
New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter E
New-Partition -DiskNumber 2 -UseMaximumSize -DriveLetter F

#########################
# Format the partitions #
#########################
Format-Volume -DriveLetter E -Force
Format-Volume -DriveLetter F -Force


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

- Overzicht van alle vagrant hosts:
=> vagrant_hosts.yml
```
- name: lampstack
  ip: 192.168.56.77
  synced_folders:
    - src: www
      dest: /var/www/html
      options:
        :owner: root
        :group: root
        :mount_options: ['dmode=0755', 'fmode=0644']
- name: monitor
  ip: 192.168.56.80
- name: loadtester
  ip: 192.168.56.81
```
=> site.yml
```
- hosts: lampstack
  sudo: true
  roles:
    - bertvv.el7
    - bertvv.httpd
    - bertvv.mariadb
    - bertvv.wordpress
    - { role: bertvv.collectd,
             collectd_plugins:
             [{ plugin: "cpu "},
              {plugin: "logfile"},
              {plugin: "memory"}],

             collectd_plugins_multi:
             {network: { Server: '192.168.56.80'}},

            tags: ["collectd"] }
- hosts: monitor
  sudo: true
  roles:
    - bertvv.el7
    - { role: bertvv.collectd,
             collectd_plugins:
              [{plugin: "logfile"}],

             collectd_plugins_multi:
             { rrdtool: { Datadir: '"/var/lib/collectd/rrd"'},
               network: { Server: '192.168.56.80'}},

            tags: ["collectd"]}
- hosts: loadtester
  sudo: true
  roles:
    - bertvv.el7
    - siege
```

-Vagrant Up problemen bij aanmaken boxen
```
! heel belangrijk bij het clonen => probleem met inventory.py !
 => destroy box
 => verwijder lampstack in directory
 => $ git clone --config core.autocrlf=input https://github.com/bertvv/lampstack
 => $ cd lampstack
 => $ ./scripts/role-deps.sh
 => vagrant up
 ```
- Alle gegevens met nodige Roles

- all.yml
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
el7_firewall_allow_services:
  - http
  - https
  - ssh
el7_firewall_allow_ports:
  - 25827/udp

httpd_scripting: 'php'

mariadb_databases:
  - wordpress

mariadb_users:
  - name: wp_user
    password: test
    priv: 'wordpress.*:ALL'


mariadb_root_password: root

wordpress_database: wordpress
wordpress_user: wp_user
wordpress_password: test
wordpress_plugins:
  - name: wp-super-cache
    version: 1.4.5
  - name: demo-data-creator
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

-Monitor.yml
```
el7_firewall_allow_services:
  - http
  - https
  
el7_install_packages:
  - bash-completion
  - git
  - tree
  - policycoreutils
  - setroubleshoot-server

el7_user_groups:
  - wheel
   
el7_repositories:
  - epel-release
el7_firewall_allow_ports:
  - 25827/udp
```
- Loading tool siege
- loadtester.yml
```

```
-Automatisatie van siege dmv aanmaken role => siege



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
* Opstelling 1:
* LAMP stack met PHP-webapplicatie opzetten met behulp van Ansible:
    - aanpassingen in yml bestanden zodat alle services draaien bij starten
    - aanmaken van een DB
    - server opzetten voor monitoring
* Loadtestingtool gebruiken voor het monitoren van de lampstack.
* Opstelling 2: multi tier web server
    - zelf kiezen welk deel apart wordt gezet
    - afhankelijk van resultaten van monitoring
Wij hebben gekozen om gebruik te maken van Siege. (http://sysadmindesk.com/web-server-load-testing-tool-siege/)

## Kanban-bord

week 1:
![screenschot TrelloWeek1] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week1.PNG?token=AGfNEuAkU6IujkKQP1Zmg342XIHKXM9jks5WRcN0wA%3D%3D)
week 2:
![screenschot week2] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week2.PNG?token=AGfNEhhz_MP8eEIDAwEbo6wvELt9w2Eqks5WRcODwA%3D%3D)
week 3:
![screenschot KanbanWeek3] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week3.PNG?token=AGfNEnHimVhQbTQew6vMgTdVcnyiPP4-ks5WRcOTwA%3D%3D)
week 4:
![screenschot TrelloWeek4] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week4.PNG?token=AGfNEvhY5CJBQ5gKqxt2zzOtsRT0vxGrks5WRcOnwA%3D%3D)
week 5:
![screenshot TrelloWeek5] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week5.PNG?token=AGfNEq98cDkdsuUSmVcfe5Q2FttIpjjrks5WRcO6wA%3D%3D)
week 6:
![screenshot week6kanban] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week6.PNG?token=AGfMlovXtiaIxhH_BCbP2BednWsjzA4kks5WQwkUwA%3D%3D)
week 7:



## Tijdbesteding

| Student  | Geschat | Gerealiseerd |
| :---     |    ---: |         ---: |
| Mathias |         |              |
| Jens |         |              |
| Sébastien |         |        |
| Jasper |         |              |

(na oplevering van de taak een schermafbeelding toevoegen van rapport tijdbesteding voor deze taak)
