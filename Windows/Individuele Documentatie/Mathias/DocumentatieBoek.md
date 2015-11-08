# Documentatie boek : Deploying and managing active directory with Windows Powershell



##Inleiding

Dit boek houdt zich voornamelijk bezig met het opstellen van active directory en hoe dit te onderhouden.
Stap voor stap zal aan bod komen hoe we via Powershell dit allemaal kunnen doen en automatiseren via scripts.

##Hoofdstuk 1: Deploy your first forest and domain.

###Commando's die in dit hoofdstuk aan bod zullen komen:
Commando                                 Betekenis
* Get-NetAdapter                        |Geeft de netwerk adapters weer
* Get-Member                            |Om meer informatie te krijgen van de adapter gebruiken we dit commando na Get-NetAdapter. Bv: Get-NetAdapter | Get-Member
* Set-NetIPAddress                      |Hiermee stellen we het IP-adres in. 
* New-NetIPAddress                      |Dit commando stelt een volledig nieuw IP-adres in. Dit commando heeft meerdere parameters nodig zoals: -AddressFamily, -InterfaceAlias, -IPAddress, -PrefixLength, -DefaultGateway
* Set-DnsClientServerAddress            |Stelt het DNS-Ip-adres in.
* Get-NetIPAddress                      |Geeft het ip-adres weer van een specifieke netwerkadapter waarvan je de naam meegeeft als parameter.
* Rename-Computer                       |Geeft de computer een andere naam.
* Install-WindowsFeature                |Installeert een windows onderdeel. Heeft als paramter het bijhorende onderdel nodig.
* Get-Command                           |Geeft commando's weer van een module die je meegeeft als parameter.
* Format-Table                          |Geef je mee in de pipeline bij een commando als je gegevens wil weergeven op basis van een kolom. Bv: Format-Table Name
* Update-Help                           |Update de helpfunctie in Powershell
* ConvertTo-SecureString                |Tekst converteren naar een beveiligde string. dit is handig voor wachtwoorden.

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

domeinmode en forestmode hangen af van welke versie van windows server je gebruik maakt.

Functional level        Numeric   String

Windows Server 2003     2         Win2003
Windows Server 2008     3         Win2008
Windows Server 2008 R2  4         Win2008R2
Windows Server 2012     5         Win2012
Windows Server 2012 R2  6         Win2012R2

##Hoofdstuk 2: Manage DNS and DHCP

###Commando's die in dit hoofdstuk aan bod zullen komen:

Commando                                    Betekenis
* Add-DnsServerPrimaryZone                  |Voegt de primary zone van de dns server toe.
* Add-DnsServerSecondaryZone                |Voegt de secondary zone van de dns server toe.
* Get-DnsServerZone                         |Haalt de dns server zones op en geeft ze weer.
* Export-DnsServerZone                      |Handig om de dns server zone te exporteren naar een file.
* Set-DnsServerPrimaryZone                  |Stelt de primary zone in van de dns.
* Set-DnsServerSecondaryZone                |Stelt de secondary zone van de dns in. 
* Add-DnsServerConditionalForwarderZone     |Voegt een forwarder zone toe , dit om requests te forwarden naar een specifiek dns domain.
* Add-DnsServerZoneDelegation               |Om grotere dns zones onder te verdelen naar kleinere zones.
* Add-DhcpServerInDC                        |Activeert dhcp in de DC.
* Add-DhcpServer4Scope                      |Voegt een scope toe waaruit de DHCP zijn adresen kan halen.

###Nieuwe primary zones creeëren.

