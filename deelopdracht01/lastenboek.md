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
```
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

```

#####1_rename_PC:
```
#############################
# Change Name of the Server #
#############################
Rename-Computer -NewName "AsSv1" -Force

#########################
# Set static ip address #
#########################
Set-NetIPInterface -InterfaceAlias "Ethernet 2" -Dhcp Disabled
New-NetIPAddress -InterfaceAlias "Ethernet 2" -IPAddress 192.168.10.5 -PrefixLength 24 -DefaultGateway 192.168.10.1
Set-DnsClientServerAddress -InterfaceAlias "Ethernet 2" -ServerAddresses 127.0.0.1

###########
# Restart #
###########
Restart-Computer
```

#####2_Create_Domain:
```
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
```

#####3_Configure_DHCP_DNS
```
#####################
# Install DHCP role #
#####################
Install-WindowsFeature -Name DHCP -IncludeManagementTools
Add-DhcpServerSecurityGroup
netsh dhcp add securitygroups
Restart-service dhcpserver

##################
# Configure DHCP #
##################
Set-DhcpServerv4Binding -BindingState $true -InterfaceAlias “Ethernet 2”
Add-DhcpServerInDC -DnsName “AsSv1.Assengraaf.nl”
Set-ItemProperty –Path registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\ServerManager\Roles\12 –Name ConfigurationState –Value 2
Add-DhcpServerv4Scope -Name "Friendly Name of Scope" -StartRange 192.168.10.100 -EndRange 192.168.10.150 -SubnetMask 255.255.255.0
Set-DhcpServerv4OptionValue -OptionId 6 -value 192.168.10.5 #DNS
Set-DhcpServerv4OptionValue -OptionId 3 -value 192.168.10.5 #Default Gateway

#############################
# Add forwarders DNS Server #
#############################
Add-DnsServerForwarder -IPAddress 8.8.8.8
Add-DnsServerForwarder -IPAddress 8.8.4.4
```
#####4_Set_Proxy
````
#################################
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
````
#####5_Create_OU_GPO
````
###############################
# Create Userfolder directory #
###############################
$Path = "E:\UserFolders"
$Name = "UserFolders$"
$Admins = "ASSENGRAAF\Domain Admins"
$Users = "ASSENGRAAF\Domain Users"

New-Item -Path $Path -ItemType directory
New-SmbShare -Name $Name -Path $Path -FullAccess $Admins
Grant-SmbShareAccess -Name $Name -AccountName $Users -AccessRight Read -Force
Grant-SmbShareAccess -Name $Name -AccountName $Users -AccessRight Change -Force

#############
# Create OU #
#############
$groups = @("Directie","Financieringen","Staf","Verzekeringen","Beheer")
$Path = "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

New-ADOrganizationalUnit -Name AsAfdelingen -ProtectedFromAccidentalDeletion $false

foreach ($group_name in $groups)
{
    New-ADOrganizationalUnit -Name $group_name `
    -Path $Path `
    -ProtectedFromAccidentalDeletion $false
}


#################
# Create groups #
#################
$groups = @("Directie","Financieringen","Staf","Verzekeringen","Beheer")

foreach ($group_name in $groups)
{
    New-ADGroup -Name "S_$group_name" -Description "Global security group voor $group_name" `
    -GroupScope Global -SamAccountName "S_$group_name" `
    -GroupCategory Security `
    -Path "OU=$group_name,OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"
}

$global_groups = @("Gebruikers","Beheerders")

foreach ($group_name in $global_groups)
{
    New-ADGroup -Name "S_$group_name" -Description "Global security group voor $group_name" `
    -GroupScope Global -SamAccountName "S_$group_name" `
    -GroupCategory Security `
    -Path "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"
}

$groups = @("Directie","Financieringen","Staf","Verzekeringen")
foreach ($group_name in $groups)
{
    $adgroup = Get-ADGroup -Identity "CN=S_$group_name,OU=$group_name,OU=AsAfdelingen,DC=Assengraaf,DC=nl"
    $group_to_add = Get-ADGroup -Identity "CN=S_Gebruikers,OU=AsAfdelingen,DC=Assengraaf,DC=nl"
    Add-ADGroupMember -Identity $group_to_add -Members $adgroup
}

$groups = @("Beheer")
foreach ($group_name in $groups)
{
    $adgroup = Get-ADGroup -Identity "CN=S_$group_name,OU=$group_name,OU=AsAfdelingen,DC=Assengraaf,DC=nl"
    $group_to_add = Get-ADGroup -Identity "CN=S_Beheerders,OU=AsAfdelingen,DC=Assengraaf,DC=nl"
    Add-ADGroupMember -Identity $group_to_add -Members $adgroup
}

###########################
# Create Departmentshares #
###########################
$shares = @("Directie","Financieringen","Staf","Verzekeringen","Beheer")
$Path = "E:\Afdelingsmappen"
$Admins = "ASSENGRAAF\Domain Admins"

New-Item -Path $Path -ItemType directory

foreach ($share_name in $shares)
{
    $full_path = $Path + "\" + $share_name
    $group_path = "S_"+$share_name
    New-Item -Path $full_path -ItemType directory

    New-SmbShare -Name $share_name -Path $full_path -FullAccess $Admins
    Grant-SmbShareAccess -Name $share_name -AccountName $group_path -AccessRight Read -Force
    Grant-SmbShareAccess -Name $share_name -AccountName $group_path -AccessRight Change -Force
    

    $full_group_path = "ASSENGRAAF\"+$group_path

    $ACL = Get-Acl $full_path
    #$ACL.SetAccessRuleProtection($true, $false)
    #$ACL.Access | ForEach { [Void]$ACL.RemoveAccessRule($_) }
    $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("ASSENGRAAF\Administrator","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")))
    $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($full_group_path,"Modify", "ContainerInherit, ObjectInherit", "None", "Allow")))
    Set-Acl $full_path $ACL

    #Remove-SmbShare -Name $share_name -Force
    #rmdir -Path $full_path -Force
    #rmdir -Peth $Path -Force
}

################
# Create Users #
################
#### Opmerking: We geven het csv-bestand mee met het script. In dit csv-bestand staan de gebruikers die we gaan toevoegen.
$Path = ".\5_werknemers.csv"
$Delimiter = ","
$principal = "@ASSENGRAAF.NL"
$main_OU = "OU=AsAfdelingen,DC=Assengraaf,DC=nl"
$profile_path = "\\AsSv1\UserFolders$\%username%"
$password = "Test123"

foreach ($User in Import-Csv -Delimiter $Delimiter -Path $Path)
{
    $OU = "OU="+ $User.OU + "," +$main_OU
    $Name = $User.GivenName + " " + $User.Surname
    $SAM = $User.GivenName.Substring(0,3) + "_" + $User.Surname.Substring(0,3)
	$UserPrincipalName = $SAM + $principal
    $homedir = "\\ASSV1\" + $User.OU
	
	#Create the user
	New-ADUser -Name $Name `
		-GivenName $User.GivenName`
		-Surname $User.Surname `
		-EmployeeNumber $User.Number `
		-SamAccountName $SAM `
		-UserPrincipalName $UserPrincipalName `
		-AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) `
		-Path $OU `
        -ProfilePath $profile_path `
        -HomeDrive 'Z:' `
        -HomeDirectory $homedir `
		-PassThru | Enable-ADAccount

    $usr = "CN=$Name,OU="+ $User.OU + ",OU=AsAfdelingen,DC=Assengraaf,DC=nl"

    $OU = "CN=S_"+ $User.OU +",OU=" + $User.OU + "," +$main_OU
    $user = Get-ADUser -Identity $usr
    Add-ADGroupMember -Identity $OU -Members $user
}

########################
# Add Femke to group's #
########################
$OU = @("CN=Account Operators,CN=Builtin,DC=Assengraaf,DC=nl","CN=Backup Operators,CN=Builtin,DC=Assengraaf,DC=nl")
$user = Get-ADUser -Identity "CN=Femke Van De Vorst,OU=Directie,OU=AsAfdelingen,DC=Assengraaf,DC=nl"

foreach ($ou_to_add in $OU)
{
    Add-ADGroupMember -Identity $ou_to_add -Members $user   
}

#####################
# Block inheritance #
#####################
$OUPath = "OU=Beheer,OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

Set-GPInheritance -Target $OUPath -IsBlocked Yes

################
# Add printers #
################
$printers = @("PFPR1","PFPR2")

Add-PrinterDriver -Name "HP Color LaserJet 2500 PS Class Driver"

foreach ($printer in $printers)
{
    $port = $printer + "PORT"
    Add-PrinterPort -Name $port
    Add-Printer -DriverName "HP Color LaserJet 2500 PS Class Driver" -Name $printer -PortName $port -Published -Shared -ShareName $printer     
}
.\pause_printers.vbs

################
# Create GPO's #
################

##### Opmerking: We geven 1 map 'GPO' mee met daarin de backupId's die we importeren in het script. In deze mappen staan de ##### te installeren eigenschappen van de group policy's. 

Import-GPO -BackupId BE233678-6586-4572-87F8-FFE93F5C53F3 -TargetName "GPOGebruikers" -Path "C:\Users\Administrator\Desktop\opdracht1\GPO\" -CreateIfNeeded
Get-GPO -Name "GPOGebruikers" | New-GPLink -Target "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

Import-GPO -BackupId 7A6D71AA-5DC3-43D9-872E-8FEDC144805C -TargetName "GPOBeheerders" -Path "C:\Users\Administrator\Desktop\opdracht1\GPO\" -CreateIfNeeded
Get-GPO -Name "GPOBeheerders" | New-GPLink -Target "OU=Beheer,OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL" -Enforced Yes

Import-GPO -BackupId 26F1E35D-F9F9-4A5A-845E-04115BFDC529 -TargetName "Default Domain Policy" -Path "C:\Users\Administrator\Desktop\opdracht1\GPO\" -CreateIfNeeded
Get-GPO -Name "Default Domain Policy" | Set-GPLink -Enforced Yes -Target "DC=ASSENGRAAF,DC=NL"

Import-GPO -BackupId A799151D-70B9-43D0-A41C-7F3890F1AB95 -TargetName "Default Domain Controllers Policy" -Path "C:\Users\Administrator\Desktop\opdracht1\GPO\" -CreateIfNeeded

gpupdate /force
````
######6_Backup
````
######################
# Add Backup feature #
######################
Add-WindowsFeature Windows-Server-Backup -IncludeManagementTools

#########################
# Define backup options #
#########################
$policy = New-WBPolicy
$BackupTargetVolume = New-WBBackupTarget -VolumePath F:
$filespec = New-WBFileSpec -FileSpec E:

Add-WBFileSpec -Policy $policy -FileSpec $filespec
Add-WBBackupTarget -Policy $policy -Target $BackupTargetVolume

##############
# Run backup #
##############
Start-WBBackup -Policy $policy
````

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
el7_motd: true
```
 - Lampstack.yml
```
# host_vars/lampstack.yml
---

el7_firewall_allow_services:
  - http
  - https
  - ssh
el7_install_packages:
  - bash-completion
  - git
  - tree
  - vim
  - policycoreutils
  - setroubleshoot-server
el7_user_groups:
  - wheel
el7_repositories:
  - epel-release
el7_firewall_allow_ports:
  - 25826/udp

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
# host_vars/loadtester.yml
---
el7_firewall_allow_services:
  - http
  - https
  - ssh
el7_install_packages:
  - bash-completion
  - git
  - vim
  - tree
  - policycoreutils
  - setroubleshoot-server

el7_user_groups:
  - wheel
   
el7_repositories:
  - epel-release
el7_firewall_allow_ports:
  - 25826/udp
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
* Opdracht Deel 1 en Deel 2 van Windows Server uitwerken via powershell.
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
