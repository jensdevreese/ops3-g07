# Project 3 Systeembeheer

## Testrapport Opdracht 1: Windows Server
## Geschreven door: Jens De Vreese
## Getest door: Jens De Vreese & Mathias Van Rumst

### Testplan

#### Overzicht
| Specificatienummer | Specificatieomschrijving |
|1|  Installeren en configureren van Server AsSv1 (AD, DHCP, DNS en Proxy) |
|2|  Installeren Werkstation AsWs1 (Domein) |
|3|   OU (AsAfdelingen aanmaken) |
|4|  Gebruikers en groepen aanmaken |
|5|   GPO's linken (met logoff script + inbraakbeveiliging) |
|6|   Instellen home directory gebruikers |
|7|   Permissies Femke van de Vorst |
|8|   Afdelingsmap instellen + permissies in orde brengen |
|9|   Werkstation in correcte OU opnemen |
|10|   Printers instellen |
|11|   Backup van gebruikersdata (eenmalig) instellen |
|12|   De server (AsSv1) updaten |
|13|   Het werkstation AsWs1 updaten |
|14|   Internet Explorer instellen via groepsbeleid |
|15|   Windows Defender instellen via groepsbeleid |
|16|   Firewall instellen via groepsbeleid |
|17|   Event viewer custom view aanmaken |
|18|   Data collector instellen |
|19|   Beveiligingsaspecten instellen |

### Testrapport

Wij beschreven hoe we de nodige specificaties kunnen testen in ons testplan.
In onderstaand overzicht en bijgevolg onderstaande screenshots bewijzen we dat de configuratie in orde en getest is.

### Bewijs van uitvoering

Onderstaande screenschots zijn het bewijs dat onze setup voldoet aan de vooropgelegde specificaties opgelegd in [Opdracht 1: Windows Server](ops3-g07/Windows/Opgave/Opdracht_project_systeembeheer_-_Windows_Server_2012_deployment_met_Powershell.pdf)

#### Proxy-server werkt

![Proxy](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/0.PNG)


#### AD en OU AsAfdelingen, GPO's Gebruikers, Beheerders

![AD, OU, GPO](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/1.PNG)
![AD, OU, GPO](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/1_1.PNG)

#### Gebruikers in groepen geplaatst, Beheerders lid van OU Beheer 

![OU Beheer](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/2.PNG)

#### Afdelingsfolder is correct ingesteld, User profile wordt opgeslaan op de server

![Afdelingsfolder](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/3a.PNG)
![Afdelingsfolder2](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/3aa.PNG)
![User profile](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/3b.PNG)


#### Inbraakbeveiliging geconfigureerd 

![Inbraakbeveiling](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/4.PNG)

#### Rechten van Femke van de Vorst instellen

![Femke van de Vorst](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/5.PNG)


#### Afdelingsmap AsSv1Data (E:) geconfigureerd 

![Afdelingsmap](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/6.PNG)


#### Werkstation is opgenomen in OU AsAfdelingen

![Werkstation in OU](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/7.PNG)

#### Printers zijn geconfigureerd

![Printers](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/8.PNG)

#### Backup is correct geconfigureerd

![Backup](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/9.PNG)

#### Updates zijn correct geconfigureerd

![Updates](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/10.PNG)

#### IE is correct geconfigureerd

![IE conf](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/12.PNG)

#### Windows defender is correct geconfigureerd

![Defender](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/13.PNG)

#### De firewall is correct geconfigureerd

![Firewall](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/14.PNG)

#### Custom view 24UursEvents correct ingesteld

![Custom view](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/15.PNG)

#### Data collector is geconfigureerd en werkt correct

![Data collector](https://github.com/HoGentTIN/g_connexus/blob/master/Lastenboek/trelloborden%20+%20testafbeeldingen/punt7.png)

#### De beveiligingsaspecten zijn van kracht

![Beveiliging](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/17.PNG)

#### Login-script werkt

![Loging-script](https://github.com/HoGentTIN/g_connexus/blob/master/Testplanrapporten/img/18.PNG)