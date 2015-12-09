# Lastenboek Taak 1: opdracht 1

* Verantwoordelijke uitvoering: `Sébastien Pattyn`
* Verantwoordelijke testen: `Jens De Vreese` , `Jasper Cottenie` , ` Mathias Van Rumst`

## Deliverables

### Windows Powershell:

* Documentatie van elk boek staat op github in [Deze] (Windows/Uitwerking powershell)
* Cheatsheets aangemaakt van Powershell, Is een document dat continu zal aangepast worden:

### Windows Deployment:
#### Scripts:
##### 0_Create_Disk:
Opmerking: Als je in virtualbox werkt, moet je zorgen dat er 2 harde schijven aanwezig zijn in de box.
```PowerShell
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

##### 1_rename_PC:
```PowerShell
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

##### 2_Create_Domain:
```PowerShell
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

##### 3_Configure_DHCP_DNS
```PowerShell
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
##### 4_Set_Proxy
```PowerShell
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
##### 5_Create_OU_Users.ps1
```PowerShell
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
$Path = ".\5_werknemers.csv"
$Delimiter = ","
$principal = "@ASSENGRAAF.NL"
$main_OU = "OU=AsAfdelingen,DC=Assengraaf,DC=nl"
$profile_path = "\\AsSv1\UserFolders$\%username%"
$password = "Test123"

#We weten dat het toevoegen van een wachtwoord in het script niet bepaald veilig is.
#Best practice is een wachtwoord zo te vragen: $secpass = Read-Host “Password” –AsSecureString
#En dan als parameter: –AccountPassword $secpass
#Dit doen we deze keer niet omwille van gemaksredenen bij het testen

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
````
##### 5_1_GPO.ps1
```PowerShell
Import-GPO -BackupId 4FAD1344-F018-4E8C-A12E-E3C9A06F9555 -TargetName "GPOGebruikers" -Path ".\ConnexusGPO\JuisteGPO" -CreateIfNeeded
Get-GPO -Name "GPOGebruikers" | New-GPLink -Target "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

Import-GPO -BackupId C3E4A3E3-4B88-4AFB-89FB-4537654BDE7C -TargetName "GPOBeheerders" -Path ".\ConnexusGPO\JuisteGPO" -CreateIfNeeded
Get-GPO -Name "GPOBeheerders" | New-GPLink -Target "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

Import-GPO -BackupId A00694BC-B2B0-4120-B822-CDC6A9961453 -TargetName "Default Domain Policy" -Path ".\ConnexusGPO\JuisteGPO" -CreateIfNeeded
Get-GPO -Name "Default Domain Policy" | New-GPLink -Enforced Yes -Target "DC=ASSENGRAAF,DC=NL"

Import-GPO -BackupId 7F683349-41D6-4842-9323-DFCB1B06AA19 -TargetName "Default Domain Controllers Policy" -Path ".\ConnexusGPO\JuisteGPO" -CreateIfNeeded

gpupdate /force
```
##### 6_Backup
```PowerShell
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
```
### Linux LAMP Stack:
- Zorg dat er gelijk wanneer in elk bestand gebruik gemaakt wordt van spaties en geen tabs. Overbodige spaties zorgen ook voor errors, dus verwijder deze ook!!

- Overzicht van alle vagrant hosts:
#### vagrant_hosts.yml
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
  ip: 192.168.56.120
```
#### site.yml
```
# site.yml
---
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
    - bertvv.httpd
    - Siege
```
#### Group_Vars/all.yml
```
collectd_server: 192.168.56.80
```
#### Host_Vars/Lampstack.yml
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

#### Host_Vars/Monitor.yml
```
# host_vars/monitor.yml
---
el7_firewall_allow_services:
  - http
  - https
  
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
```
#### Host_Vars/loadtester.yml
```
# host_vars/loadtester.yml
---
el7_repositories:
  - epel-release

el7_install_packages:
  - bash-completion
  - policycoreutils
  - setroubleshoot-server
  - tree
  - vim-enhanced

el7_firewall_allow_services:
  - http
  - https
  - ssh

el7_firewall_allow_ports:
  - 25826/udp

el7_user_groups:
  - wheel

siege_targets:
  - 192.168.56.77/wordpress 
```
### Rollen
#### Loadtesting tool: Siege
Deze hebben we in ons lastenboek opgenomen, omdat we deze rol zelf gemaakt hebben.
```
# roles/siege/tasks/main.yml
---

# Download en unzip Siege en zet hem in de Home directory van de vagrant host.
#- name: Download Siege
#  get_url: url=http://download.joedog.org/siege/siege-3.1.0.tar.gz dest=/home/vagrant/ mode=0777
# unzippen

- name: copy siege tar
  copy:
    src: siege-3.1.0.tar.gz
    dest: /home/vagrant
  tags: tarcopy

- unarchive: src=/home/vagrant/siege-3.1.0.tar.gz dest=/home/vagrant/ copy=no

- name: install the 'Development tools' package group
  yum: name="@Development tools" state=present

- name: Configure and complete the installation process
  command: sudo {{ item }} chdir="/home/vagrant/siege-3.1.0"
  with_items:
    - ./configure
    - make
    - make install
    
- name: copy .siegerc
  copy:
    src: .siegerc
    dest: /home/vagrant
  tags: siege

- name: Make var-directory
  file: path=/usr/local/var state=directory mode=0777

- name: Make siegelog-file 
  file: path=/usr/local/var/siege.log state=touch mode=0777
  tags: siege

- name: copy yomoni tar
  copy:
    src: Yomoni.tar.gz
    dest: /home/vagrant
  tags: siege

- unarchive: src=/home/vagrant/Yomoni.tar.gz dest=/home/vagrant copy=no

- name: copy targets
  template: 
    src: urls.txt
    dest: /usr/local/etc/
  tags: siege

- name: extracting website tar to /var/www/html
  copy:
    src: Website.tar.gz
    dest: /var/www/html/
  tags: siege

- unarchive: src=/var/www/html/Website.tar.gz dest=/var/www/html/ copy=no

- name: setting permissions
  command: sudo chmod -R 777 /var/www/html

- name: cleaning up yomoni-tar
  command: sudo rm /home/vagrant/Yomoni.tar.gz

- name: cleaning up siege-tar
  command: sudo rm /home/vagrant/siege-3.1.0.tar.gz

- name: cleaning up html-folder
  command: sudo rm /var/www/html/Website.tar.gz
```
#### Overige rollen
De overige rollen die wij gebruiken voor in onze collectd server en de lampstack kan u [hier] (Linux/lampstack/ansible/roles/) raadplegen


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

### Linux LAMP Stack:
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
![screenschot TrelloWeek1] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week1.PNG?token=AGfMlmq1is_l07e7RFvn0fHC0vS-haS2ks5WcHgTwA%3D%3D)
week 2:
![screenschot week2] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week2.PNG?token=AGfMlsdNY9s2vQOhnIIJpzeJm1BMtCN9ks5WcHgVwA%3D%3D)
week 3:
![screenschot KanbanWeek3] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week3.PNG?token=AGfMlunK6C-9Q6Ouy3oPmJp1qPLTTGmpks5WcHgZwA%3D%3D)
week 4:
![screenschot TrelloWeek4] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week4.PNG?token=AGfMljBhtbBi4mV5oZDryP-R2whZCCi9ks5WcHgZwA%3D%3D)
week 5:
![screenshot TrelloWeek5] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week5.PNG?token=AGfMlmh_n9XqoNp4-RnlvyL2cUuEcpsiks5WcHgZwA%3D%3D)
week 6:
![screenshot week6kanban] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week6.PNG?token=AGfMlvwpF4iQ97I1W-ddNA5tsXy3K88Yks5WcHgbwA%3D%3D)
week 7:
![screenshot week7kanban] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week7.PNG?token=AGfMlih9lrpU1z_t2mqSxDwo1WCpNUrSks5WcHgdwA%3D%3D)
week 8:
![screenshot week7kanban] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/Kanban%20week8.PNG?token=AGfMlg1KutfhL08TDLoTsggntQjl4AcQks5WcHgfwA%3D%3D)
week 9:
![screenshot week7kanban] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/KanbanWeek9.PNG?token=AGfMlrno6nyqaWoGs-z8c1GHkBb6mKPyks5WcHghwA%3D%3D)
week 10:
![screenshot week7kanban] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/KanbanWeek10.PNG?token=AGfMlvRl1twJHrnasXn8CokYjZYpHjl6ks5WcHgiwA%3D%3D)
week 11:
![screenshot week7kanban] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/KanbanWeek11.PNG?token=AGfMluMNMBHN4bt-RwG3w3wIxRomTfE6ks5WcHgkwA%3D%3D)
week 12:
![screenshot week7kanban] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Images/Trello/KanbanWeek12.PNG?token=AGfMljAdw0OH0ndRWPk82iIDVoCkf_Owks5WcHglwA%3D%3D)




## Tijdbesteding

| Student  | Geschat | Gerealiseerd |
| :---     |    ---: |         ---: |
| Mathias |         |              |
| Jens |         |              |
| Sébastien |         |        |
| Jasper |         |              |

(na oplevering van de taak een schermafbeelding toevoegen van rapport tijdbesteding voor deze taak)
