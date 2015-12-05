# Documentatie boek : Deploying and managing active directory with Windows Powershell



##Inleiding

Dit boek houdt zich voornamelijk bezig met het opstellen van active directory en hoe dit te onderhouden.
Stap voor stap zal aan bod komen hoe we via Powershell dit allemaal kunnen doen en automatiseren via scripts.

##Hoofdstuk 1: Deploy your first forest and domain.

###Commando's die in dit hoofdstuk aan bod zullen komen:

| Commando                   | Betekenis                                                                                                                                                                          |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Get-NetAdapter             | Geeft de netwerk adapters weer                                                                                                                                                     |
| Get-Member                 | Om meer informatie te krijgen van de adapter gebruiken we dit commando na Get-NetAdapter. Bv: Get-NetAdapter | Get-Member                                                          |
| Set-NetIPAddress           | Hiermee stellen we het IP-adres in.                                                                                                                                                |
| New-NetIPAddress           | Dit commando stelt een volledig nieuw IP-adres in. Dit commando heeft meerdere parameters nodig zoals: -AddressFamily, -InterfaceAlias, -IPAddress, -PrefixLength, -DefaultGateway |
| Set-DnsClientServerAddress | Stelt het DNS-Ip-adres in.                                                                                                                                                         |
| Get-NetIPAddress           | Geeft het ip-adres weer van een specifieke netwerkadapter waarvan je de naam meegeeft als parameter.                                                                               |
| Rename-Computer            | Geeft de computer een andere naam.                                                                                                                                                 |
| Install-WindowsFeature     | Installeert een windows onderdeel. Heeft als paramter het bijhorende onderdel nodig.                                                                                               |
| Get-Command                | Geeft commando's weer van een module die je meegeeft als parameter.                                                                                                                |
| Format-Table               | Geef je mee in de pipeline bij een commando als je gegevens wil weergeven op basis van een kolom. Bv: Format-Table Name                                                            |
| Update-Help                | Update de helpfunctie in Powershell                                                                                                                                                |
| ConvertTo-SecureString     | Tekst converteren naar een beveiligde string. dit is handig voor wachtwoorden.                                                                                                                                                                                   |

###Fixed IP-adres instellen voorafgegaan door DHCP op een netwerk adapter uit te zetten.
* DHCP uitzetten
Set-NetIPInterface -InterfaceAlias "10 Network" -DHCP Disabled -PassThru
* Netwerkadapter instellen
New-NetIPAddress `
-AddressFamily IPv4 `
-InterfaceAlias "10 Network" `
-IPAddress 192.168.10.2 `
-PrefixLength 24 `
-DefaultGateway 192.168.10.1

###DNS adres instellen

Set-DnsClientServerAddress `
-InterfaceAlias "10 Network" `
-ServerAddresses 192.168.10.2

Om alles te verifiëren gebruiken we het volgende commando:
Get-NetIPAddress -InterfaceAlias "10 Network"

###Servernaam instellen

Rename-Computer -NewName DC -Restart -Force -PassThru

###Istalleren van onderdeel AddressFamily

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

###DC en forest aanmaken

Install-ADDSForest `
-DomainName 'domeinnaam.net' `
-DomainNetBiosName 'DOMEINNAAM' `
-DomainMode 6 `
-ForestMode 6 `
-NoDnsOnNetwork `
-SkipPreChecks `
-Force 

Domeinmode en forestmode hangen af van welke versie van windows server je gebruik maakt.

| Functional level       | Numeric | String    |
|------------------------|---------|-----------|
| Windows Server 2003    | 2       | Win2003   |
| Windows Server 2008    | 3       | Win2008   |
| Windows Server 2008 R2 | 4       | Win2008R2 |
| Windows Server 20012   | 5       | Win2012   |
| Windows Server 2012    | 6       | Win2012R2 |

##Hoofdstuk 2: Manage DNS and DHCP

###Commando's die in dit hoofdstuk aan bod zullen komen:

| Commando                   | Betekenis                                                                                                                                                                          |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Get-NetAdapter             | Geeft de netwerk adapters weer                                                                                                                                                     |
| Get-Member                 | Om meer informatie te krijgen van de adapter gebruiken we dit commando na Get-NetAdapter. Bv: Get-NetAdapter | Get-Member                                                          |
| Set-NetIPAddress           | Hiermee stellen we het IP-adres in.                                                                                                                                                |
| New-NetIPAddress           | Dit commando stelt een volledig nieuw IP-adres in. Dit commando heeft meerdere parameters nodig zoals: -AddressFamily, -InterfaceAlias, -IPAddress, -PrefixLength, -DefaultGateway |
| Set-DnsClientServerAddress | Stelt het DNS-Ip-adres in.                                                                                                                                                         |
| Get-NetIPAddress           | Geeft het ip-adres weer van een specifieke netwerkadapter waarvan je de naam meegeeft als parameter.                                                                               |
| Rename-Computer            | Geeft de computer een andere naam.                                                                                                                                                 |
| Install-WindowsFeature     | Installeert een windows onderdeel. Heeft als paramter het bijhorende onderdel nodig.                                                                                               |
| Get-Command                | Geeft commando's weer van een module die je meegeeft als parameter.                                                                                                                |
| Format-Table               | Geef je mee in de pipeline bij een commando als je gegevens wil weergeven op basis van een kolom. Bv: Format-Table Name                                                            |
| Update-Help                | Update de helpfunctie in Powershell                                                                                                                                                |
| ConvertTo-SecureString     | Voegt een scope toe waaruit de DHCP zijn adresen kan halen.                                                                                                                                                                                   |

###Nieuwe primary zones creeëren.
Add-DnsServerPrimaryZone -Name 'primaryzone.com' `
                         -ComputerName 'computername.net' `
                         -ReplicationScope 'Domain' `
                         -DynamicUpdate 'Secure' `
                         -PassThru

###Primary zone met netwerk.
Add-DnsServerPrimaryZone -NetworkID 192.168.10.0/24 `
                         -ReplicationScope 'Forest' `
                         -DynamicUpdate 'NonsecureAndSecure' `
                         -PassThru

###Secondary zone aanmaken.
Add-DnsServerSecondaryZone –Name 0.1.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa `
                           -ZoneFile "0.1.0.0.0.0.0.0.8.b.d.0.1.0.0.2.ip6.arpa.dns" `
                           -LoadExisting `
                           -MasterServers 192.168.10.2,2001:db8:0:10::2 `
                           -PassThru

                        
###DHCP installeren
Install-WindowsFeature -ComputerName trey-dns-03 `
                       -Name DHCP `
                       -IncludeAllSubFeature `
                       -IncludeManagementTools


###DNS instellen in DHCP.
Add-DhcpServerInDC -DnsName 'name-dns-03' -PassThru


###DHCP configureren.
Add-DhcpServerv4Scope -Name "Name-Default" `
                      -ComputerName "name-dns-03" `
                      -Description "Default IPv4 Scope for Lab" `
                      -StartRange "192.168.10.1" `
                      -EndRange   "192.168.10.200" `
                      -SubNetMask "255.255.255.0" `
                      -State Active `
                      -Type DHCP `
                      -PassThru

###DHCP scope toevoegen.
Add-DhcpServerv4ExclusionRange -ScopeID "192.168.10.0" `
                               -ComputerName "name-dns-03" `
                               -StartRange "192.168.10.1" `
                               -EndRange   "192.168.10.20" `
                               -PassThru

                     
###DHCP opties toevoegen.
Set-DhcpServerv4OptionValue -ScopeID 192.168.10.0 `
                            -ComputerName "name-dns-03" `
                            -DnsDomain "Name.net" `
                            -DnsServer "192.168.10.2" `
                            -Router "192.168.10.1" `
                            -PassThru

                            
##Hoofdstuk 3: Create and manage users and groups.

###Commando's die in dit hoofdstuk aan bod zullen komen:

| Commando                 | Betekenis                                                                                                                                                  |
|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ADUser                   | Kan voorafgegaan worden door Get of New. Dit om de user op te vragen of hem aan te maken met bijhorende parameters zoals bijvoorbeeld -Name                |
| ADGroup                  | Kan voorafgegaan worden door Get of New. Dit om een nieuwe group  op te vragen of hem aan te maken.                                                        |
| ADGroupMember            | Kan voorafgegaan worden door Add. Dit om een user toe te voegen aan een group. Of door                                                                     |
| ADAccountPassword        | Wordt gebruikt om het wachtwoord in te stellen van een useraccount.                                                                                        |
| New-ADOrganizationalUnit | Wordt gebruikt om een nieuwe organizational unit aan te maken om de users in onder te verdelen of de computers.                                            |
| ADObject                 | Wordt voorafgegaan door Move. Dit om een object in de AD te verplaatsen. Bijvoorbeeld een computer of user die verkeerd staan.                             |
| ADComputer               | Wordt vorafgegaan door Get. Om een computer uit de AD op te halen.                                                                                         |
| Import-CSV               | Dit wordt gebruikt voor het vergemakkelijken van het toevoegen van users. Steek ze eerst in een .csv bestand met bijhorende waarden en importeer deze dan. |

###Een user aanmaken

New-ADUser -Name "Mathias Van Rumst" `
           -AccountPassword $SecurePW  `
           -SamAccountName 'Mathias' `
           -DisplayName 'Mathias Van Rumst' `
           -EmailAddress 'mvr@email.net' `
           -Enabled $True `
           -GivenName 'Mathias' `
           -PassThru `
           -PasswordNeverExpires $True `
           -Surname 'Van Rumst' `
           -UserPrincipalName 'Mathias'

###Nieuwe group aanmaken

New-ADGroup –Name 'Accounting Users' `
            -Description 'Security Group for all accounting users' `
            -DisplayName 'Accounting Users' `
            -GroupCategory Security `
            -GroupScope Universal `
            -SAMAccountName 'AccountingUsers' `
            -PassThru


###User toevoegen aan een group

Add-ADGroupMember -Identity AccountingUsers -Members Mathias,Stanley -PassThru

###Nieuwe organizational unit aanmaken.

New-ADOrganizationalUnit -Name Engineering `
                         -Description 'Engineering department users and computers' `
                         -DisplayName 'Engineering Department' `
                         -ProtectedFromAccidentalDeletion $True `
                         -Path "DC=TreyResearch,DC=NET" `
                         -PassThru

##Hoofdstuk 4: Deploy additional domain controllers.

###Commando's die in dit hoofdstuk aan bod zullen komen:

| Commando                         | Betekenis                                                                                                                                                 |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| ADDSDomainController             | Wordt voorafgegaan door Install-. Dit installeert de DomainController. Er zijn parameters mogelijk om bijvorbeeld DN te activeren : InstallDns:$true.     |
| ADDSDomainControllerInstallation | Wordt voorafgegaan door Test-. Om te controleren of alle instelingen juist zijn van de installatie van de DomainController                                |
| ADComputer                       | Wordt voorafgegaan door Add-. Om een computer toe te voegen aan de active directory.                                                                      |
| ADGroupMember                    | Wordt voorafgegaan door Ad-. Om bijvoorbeeld een domain controller toe te voegen aan een groep van kloonbare domain controllers. Ook Remove- is mogelijk. |
| ADComputerServiceAccount         | Meestal gebruikt voorafgegaan door het Get-. commando. Dit om het service account van de active directory weer te geven.                                  |
| ADServiceAccount                 | Wordt gebruikt om het active directory account aan te maken.                                                                                              |
| ADDomain                         | Door middel van Get kan je het active directory opvragen.                                                                                                 |
| ADForest                         | Door middel van Get kan je het forest niveau opvragen.                                                                                                    |
| ADDomainController               | Door middel van Get kan je info over de domain controller opvragen.                                                                                       |
| Import-Module                    | Importeert een module in de server.                                                                                                                       |

###Active directory installeren                                                                                                                                              |
                         
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

###Domain controller installeren.

Install-ADDSDomainController `
      -SkipPreChecks `
      -NoGlobalCatalog:$false `
      -CreateDnsDelegation:$false `
      -CriticalReplicationOnly:$false `
      -DatabasePath "C:\Windows\NTDS" `
      -DomainName "TreyResearch.net" `
      -InstallDns:$true `
      -LogPath "C:\Windows\NTDS" `
      -NoRebootOnCompletion:$false `
      -SiteName "Default-First-Site-Name" `
      -SysvolPath "C:\Windows\SYSVOL" `
      -Force:$true

###Domain controller toevoegen aan securitygroup

Add-ADGroupMember -Identity "Cloneable Domain Controllers" `
                  -Members (Get-ADComputer -Identity dc).SAMAccountName `
                  -PassThru


##Hoofdstuk 5: Deploy read-only domain controllers (RODCs)


###Commando's die in dit hoofdstuk aan bod zullen komen:

| Commando                            | Betekenis                                                                                            |
|-------------------------------------|------------------------------------------------------------------------------------------------------|
| ADDSReadOnlyDomainControllerAccount | Wordt voorafgegaan door Add-. Dit voegt het service account toe voor de read only domain controller. |

###Service account toevoegen voor de RODC.

Add-ADDSReadOnlyDomainControllerAccount `
      -DomainControllerAccountName "rodc" `
      -DomainName "domain.net" `
      -SiteName "Default-First-Site-Name" `
      -DelegatedAdministratorAccountName "DOMAIN\Mathias" `
      -InstallDNS `
      -AllowPasswordReplicationAccountName "Dave","Fred","Mathias"

###De RODC deployen.

Install-WindowsFeature `
     -Name AD-Domain-Services `
     -IncludeAllSubFeature `
     -IncludeManagementTools


###Overige instellingen.

Voor de overige instellingen kan je terugkijken naar het hoofdstuk voor het deployen van een domain controller.

##Hoofdstuk 6: Deploy additional domains and forests.


###Commando's die in dit hoofdstuk aan bod zullen komen:

Geen nieuwe commando's die in dit hoofdstuk aan boek komen. Zie hoofdstuk 1 voor de commando's voor het installeren van een forest en domain.

###Nieuwe domain testen en instellen.

$myDomCreds = Get-Credential -UserName "domain\Mathias" `
                             -Message "Enter Domain Password"
Test-ADDSDomainInstallation `
      -NoGlobalCatalog:$false `
      -CreateDnsDelegation:$True `
      -Credential $myDomCreds `
      -DatabasePath "C:\Windows\NTDS" `
      -DomainMode "Win2012R2" `
      -DomainType "ChildDomain" `
      -InstallDns:$True `
      -LogPath "C:\Windows\NTDS" `
      -NewDomainName "tweededomain" `
      -NewDomainNetbiosName "TWEEDEDOMAIN" `
      -ParentDomainName "domain.net" `
      -NoRebootOnCompletion:$False `
      -SiteName "Default-First-Site-Name" `
      -SysvolPath "C:\Windows\SYSVOL" `
      -Force:$True

Install-ADDSDomain -NoGlobalCatalog:$false `
                   -Credential $myDomCreds `
                   -DatabasePath "C:\Windows\NTDS" `
                   -DomainMode "Win2012R2" `
                   -DomainType "TreeDomain" `
                   -InstallDns:$True `
                   -LogPath "C:\Windows\NTDS" `
                   -NewDomainName "WingtipToys.com" `
                   -NewDomainNetbiosName "WINGTIP" `
                   -ParentDomain "TreyResearch.net"
                   -NoRebootOnCompletion:$False `
                   -SiteName "Default-First-Site-Name" `
                   -SysvolPath "C:\Windows\SYSVOL" `
                   -Force:$True

      
##Hoofdstuk 7: Configure service authentication and account policies.


###Commando's die in dit hoofdstuk aan bod zullen komen:

| Commando                          | Betekenis                                                                                                                                                           |
|-----------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Get-ADDefaultDomainPasswordPolicy | Wordt gebruikt om de default domain password policy weer te geven.                                                                                                  |
| New-ADFineGrainedPasswordPolicy   | Stelt een nieuwe policy in voor het wachtwoord van een gebruiker met een bijhorende beschrijving. Bijvoorbeeld: Stel een nieuw wachtwoord in met maximum 12 tekens. |
| New-ScheduledTaskAction           | Maakt een nieuwe taak aan die op een geregeld tijdstip wordt uitgevoerd.                                                                                            |
| Register-ScheduledTask            | Registreert de taak die je hebt aangemaakt.

###Wachtwoord instellingen wijziging

New-ADFineGrainedPasswordPolicy `
     -description:"Set minimum 12 character passwords for all Executives." `
     -LockoutDuration 00:10:00 `
     -LockoutObservationWindow 00:10:00 `
     -LockoutThreshold 5 `
     -MaxPasswordAge 65.00:00:00 `
     -MinPasswordLength 12 `
     -Name:"Executive Users Pwd Policy" `
     -Precedence 10 `
     -PassThru

###Default domain password policy instellen.

Get-ADDefaultDomainPasswordPolicy -Identity TreyResearch.net `
    | Set-ADDefaultDomainPasswordPolicy -LockoutThreshold 10 `
                                        -LockoutDuration 00:10:00 `
                                        -LockoutObservationWindow 00:10:00 `
                                        -MinPasswordLength 10 `
                                        -MaxPasswordAge 100.00:00:00 `
                                        -PassThru

     
##Hoofdstuk 8: Back up and restore AD DS.


###Commando's die in dit hoofdstuk aan bod zullen komen:

| Commando                    | Betekenis                                                                                                   |
|-----------------------------|-------------------------------------------------------------------------------------------------------------|
| ADSnapshot                  | Maakt een snapshot van de active directory. Dit is een soort copy die dan kan gebruikt worden voor ecovery. |
| Enable-ADOptionalFeature    | Zet een optionele feature aan. ZOals de Recycle Bin Feature om de kopie terug te zetten van een snapshot.   |
| WBPolicy                    | Voegt een policy toe aan de windows backup(New-). Of haalt ze op. (Get-)                                    |
| WBVolume                    | Wordt voorafgegaan door Get-, Set-, Add-. Om een windows backup volume aan te maken of op te vragen.        |
| Set-WBDisk                  | Stelt de windows backup in op een harde schijf.                                                             |
| WBFileSpec                  | Wordt voorafgegaan door New-. om en file path toe te voegen.                                                |
| WBBackup                    | Wordt voorafgegaan door Start-. Dit om de backup te starten.                                                |
| Start-WBSystemStateRecovery | Start de recovery van het systeem naar een vorige staat van de machine.                                     |

###Windows Backup installeren.

Install-WindowsFeature -Name Windows-Server-Backup
Update-Help -Module WindowsServerBackup -Force

###Een WBVolume object toevoegen.

$wbVol = Get-WBVolume -VolumePath C:
Add-WBVolume -Policy $newWBPol -Volume $wbVol

###Een WBFileSpec toevoegen.

$incFSpec = New-WBFileSpec -FileSpec "D:\","C:\Temp"
$excFSpec = New-WBFileSpec -FileSpec "D:\PSHelp" -Exclude

Add-WBFileSpec -Policy $newWBPol -FileSpec $incFSpec
Add-WBFileSpec -Policy $newWBPol -FileSpec $excFSpec


###Uur aanpassen wanneer de backup altijd plaats vindt

Set-WBSchedule -Policy $newWBPol -Schedule 12:00,20:00

##Hoofdstuk 9: Manage sites and replication.


###Commando's die in dit hoofdstuk aan bod zullen komen:

| Commando                               | Betekenis                                                          |
|----------------------------------------|--------------------------------------------------------------------|
| New-ADReplicationSite                  | Een nieuwe site aanmaken  door een oude site te repliceren.        |
| New-ADReplicationSubnet                | Het subnet van de gerepliceerde site creëren.                      |
| Get-ADDCCloningExcludedApplicationList | Haalt een lijst met applicaties op die niet worden gerepliceert.   |
| ADDCCloneConfigFile                    | Maakt een kopie van de configuratie file van de domain controller. |
| NetFirewallRule                        | Voegt een nieuwe firewall regel toe.                               |
| Enable-PSRemoting                      | Zet powershell remoting aan.  

###Nieuwe site creëren door replicatie.

New-ADReplicationSite -Name Redmond-11 `
                      -Description "The .11 site/subnet on the Redmond Campus" `
                      -PassThru

###Nieuw subnet aanmaken door eplicatie.

New-ADReplicationSubnet -Name "192.168.11.0/24" `
                        -Site "Redmond-11" `
                        -Location "Redmond, WA" `
                        -PassThru


##Hoofdstuk 10: Deploy Active Directory in the cloud.


###Commando's die in dit hoofdstuk aan bod zullen komen:  

| Commando         | Betekenis                             |
|------------------|---------------------------------------|
| Add-AzureAccount | Voegt een windows Azure  account toe. |

###Windows Azure module importeren.

Import-Module Azure –PassThru

###Verdere configuratie Azure.

Een verdere configuratie van windows azure gebeurt met een GUI. Je kan wel je windows azure account opvragen door middel van het commando: Get-AzureAccount.

                          