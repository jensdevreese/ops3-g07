# Project 3 Systeembeheer

## Testrapport Opdracht 1: Windows Server
## Geschreven door: Jens De Vreese
## Getest door: Jens De Vreese, Mathias Van Rumst


### Deeltaken
| Specificatienummer | Specificatieomschrijving                                              |
|--------------------|-----------------------------------------------------------------------|
| 1                  | Installeren en configureren van Server AsSv1 (AD, DHCP, DNS en Proxy) |
| 2                  | Installeren Werkstation AsWs1 (Domein)                                |
| 3                  | OU (AsAfdelingen aanmaken)                                            |
| 4                  | Gebruikers en groepen aanmaken                                        |
| 5                  | GPO's linken (met logoff script + inbraakbeveiliging)                 |
| 6                  | Instellen home directory gebruikers                                   |
| 7                  | Permissies Femke van de Vorst                                         |
| 8                  | Afdelingsmap instellen + permissies in orde brengen                   |
| 9                  | Werkstation in correcte OU opnemen                                    |
| 10                 | Printers instellen                                                    |
| 11                 | Backup van gebruikersdata (eenmalig) instellen                        |
| 12                 | De server (AsSv1) updaten                                             |
| 13                 | Het werkstation AsWs1 updaten                                         |
| 14                 | Internet Explorer instellen via groepsbeleid                          |
| 15                 | Windows Defender instellen via groepsbeleid                           |
| 16                 | Firewall instellen via groepsbeleid                                   |
| 17                 | Event viewer custom view aanmaken                                     |
| 18                 | Data collector instellen                                              |
| 19                 | Beveiligingsaspecten instellen                                        |

### Testplan
#### Server:
- De nodige OU's zichtbaar zijn in de management console
- Het werkstation in de juiste OU zichtbaar is in de management console
- De backup zichtbaar is en genomen door femke
- Als er geen nieuwe gewenste updates gevonden worden
- Als de custom view de events van de laatste 24u weergeeft
- De data collector de juiste gegevens weergeeft

#### werkstation
- Internet heeft
- Ip adres van domaincontroller heeft
- Kan inloggen met een domain account
- Connecteren met printer
- Logoffscript werkt
- De updates om 12u geinstalleerd worden
- Als het windows defender configuratie scherm meldt dat "de computer beschermd is"
- Als de instelling "eerst updaten voor scannen" aan staat
- Als firewall:
"Domain Profile" ingesteld is op natuurlijk gedrag
"Public Profile" ingesteld is op natuurlijk gedrag en niet antwoord op "ping"

#### gebruikers
- Zijn homedirectory kan benaderen
- Zijn afdelingsmap kan benaderen
- Gebruiker niet meer kan inloggen na 3 foutieve pogingen
- Als in internet explorer de beveiligingsinstellingen, privacy instellingen, content­advisor, xss filter ingeschakeld zijn en "internet options" niet meer bruikbaar zijn (behalve voor beheerder)

##### gebruiker Femke Van De Vorst
- een backup kan uitvoeren
- een geblokeerde gebruiker kan deblokkeren

### Testrapport

Wij beschreven hoe we de nodige specificaties kunnen testen in ons testplan.
In onderstaand overzicht en bijgevolg onderstaande screenshots bewijzen we dat de configuratie in orde en getest is.

#### Bewijs van uitvoering

Onderstaande screenschots zijn het bewijs dat onze setup voldoet aan de vooropgelegde specificaties opgelegd in [Opdracht 1: Windows Server](ops3-g07/Windows/Opgave/Opdracht_project_systeembeheer_-_Windows_Server_2012_deployment_met_Powershell.pdf)

##### Schijven E en F aangemaakt
Jens x
##### Hostname server en Ip-configuratie correct ingesteld.
Jens x
##### AD
Jens x
##### OU AsAfdelingen
Mathias x
##### GPO's 
Mathias x
##### Gebruikers (+Beheerders)
Mathias x
##### Gebruikers in groepen geplaatst, Beheerders lid van OU Beheer 
Mathias x
##### Afdelingsfolder is correct ingesteld, User profile wordt opgeslaan op de server
Mathias x
##### Proxy-server werkt
Mathias/Jens x
##### Inbraakbeveiliging geconfigureerd 
Jasper x
###### Signin methode not allowed => fixen

##### Rechten van Femke van de Vorst instellen
Jasper
##### Afdelingsmap AsSv1Data (E:) geconfigureerd 
Mathias x
##### Werkstation is opgenomen in OU AsAfdelingen
Mathias x
##### Printers zijn geconfigureerd
Mathias x
=> nog extra afbeelding (control panel) toevoegen 
##### Backup is correct geconfigureerd
Mathias x
##### Updates zijn correct geconfigureerd
ToDo
##### IE is correct geconfigureerd
Jens x
##### Windows defender is correct geconfigureerd
ToDo
##### De firewall is correct geconfigureerd
Jens x
##### Custom view 24UursEvents correct ingesteld
Jens x
Opmerking: xml-file meegegeven, maar moet nog manueel geimporteerd worden.
##### Data collector is geconfigureerd en werkt correct
Not done via PS. Manueel invoeren.
##### De beveiligingsaspecten zijn van kracht
Jasper x
##### Login-script werkt
ToDo
