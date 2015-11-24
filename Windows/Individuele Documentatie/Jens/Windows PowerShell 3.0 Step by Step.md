# Windows PowerShell 3.0: Step by step [by Ed Wilson]
## Overzicht hoofdstukken
- Hoofdstuk 1: Overview of Windows PowerShell 3.0
- Hoofdstuk 2: Using Windows PowerShell Cmdlets
- Hoofdstuk 3: Understanding and Using PowerShell Providers
- Hoofdstuk 4: Using PowerShell Remoting and Jobs
- Hoofdstuk 5: Using PowerShell Scripts
- Hoofdstuk 6: Working with Functions
- Hoofdstuk 7: Creating Advanced functions and Modules
- Hoofdstuk 8: Using the Windows PowerShell ISE
- Hoofdstuk 9: Working with Windows PowerShell Profiles
- Hoofdstuk 18: Debugging Scripts
- Hoofdstuk 19: Handling Errors
- Hoofdstuk 20: Managing Exchange Server
- Extra: Cheatsheet

## Inleiding
Dit boek is geschreven door Ed Wilson. Het is de bedoeling van dit boek dat je een goede kennis opdoet van Windows PowerShell 3.0 technologie. Als je nieuw bent voor Windows Powershell, dan wordt er van je verwacht dat je je voornamelijk concentreert op de hoofdstukken 1 tot en met 3 en 5 tot en met 9. Aangezien wij beginnen vanaf nul, gaan wij deze volgorde nemen. Wij zullen de eerste 9 hoofdstukken, met uitzondering van hoofdstuk 4, doornemen en goed bijhouden wat belangrijk is voor dat hoofdstuk. Op deze manier krijgen we een bondige samenvatting voor beginnend powershellgebruik.
## Hoofdstuk 1: Overview of Windows PowerShell 3.0
Windows Powershell kan als vervanging gebruikt worden voor de CMD (command) shell.  Zo kan je bijvoorbeeld gebruik maken van cd en dir in Windows PowerShell om te navigeren door je directorytree van je systeem. Belangrijk is dat je de structuur van cmdlets kent. Cmdlets, eigenlijk een andere naam voor commando’s, bestaan telkens uit ** een werkwoord** gevolgd door een **streepje** en **een zelfstandig** naamwoord  (bv: `Get-Help,Set-Service`). Get: Geeft informatie , Set: Veranderd informatie.

Het is mogelijk om meerdere commando’s tegelijk te gebruiken. Bv:
`>  ipconfig /all >tshoot.txt; route print >>tshoot.txt`
Dit commando zal de uitvoer van ipconfig en route print in de tshoot.txt-file zetten.

Een van de belangrijkste updates van powershell, is het gebruik van `–whatif` en `–confirm`. Dit zijn argumenten die op het einde van een commando kunnen ingevoegd worden, zodanig dat vooraleer je een commando uitvoert, je eerst de mogelijk uitvoer krijgt. Op deze manier kom je niet voor verrassingen te staan, en zal je op voorhand weten wat het uitvoerende commando zal doen. Bij confirm zal je een confirmatie-vraag krijgen. vb:

1. Open Notepad door in de powershell `notepad` te typen.
2. Kijk wat het procesID is door gebruik te maken van het commando `Get-Process note*`
   Gebruik maken van een * is een groot voordeel in powershell. Dit kan je beschouwen als een wildcard. Stel dat je een lijst wilt van alle get-commando’s die beginnen met een H, dan kan je get-H* typen, en krijg je als resultaat alle mogelijk get commando’s die beginnen met een H.
3. Gebruik het –confirm/-whatif  argument bij het stoppen van het proces van notepad:
`> Stop-Process –id 1768 –confirm`
   Het processID van notepad is in ons geval 1768
4. Als je dit commando uitvoer zal je de vraag krijgen of je zeker bent dat je deze actie wilt uitvoeren. Dan moet de gebruiker vervolgens bevestigen of annuleren.

### De helpfunctie
Vooraleer je start met het gebruik van windows powershell is het belan0grijk dat je het volgende commando uitvoert:
`> Update-Help _module * -Force`
Dit zorgt er voor dat je de laatste nieuwe versie hebt van de help-functie. De helpfunctie word enorm veel gebruikt. Daarom is het van belang dat je de laatste nieuwe info hebt.
Ik zou je nu kunnen uitleggen hoe de help-functie werkt, maar al doende leert men beter. Daarom type je het commando: `> Get-Help Get-Help.` Dit zal je een uitvoerige beschrijving geven over hoe de Get-help functie werkt.  Dat is hoe de help-functie werkt. Je typt het commando `Get-Help` gevolgt door het commando waarover je hulp wilt krijgen. Stel dat je niet meer weet hoe het commando precies gaat, maar je weet dat het commando begint met een ‘p’, dan geef je het commando `Get-Help get-p*`. Stel dat je wel weet hoe het commando geschreven wordt, maar je weet niet meer hoe de syntax daarvan uitziet, dan kan je gebruik maken van `Get-Help` met het  `–examples` argument. (bv` Get-Help Get-PSDrive –examples`)
De helpfunctie heeft drie verschillende weergaven, een normale, een gedetailleerde en een volledige weergave. Dit zijn argumenten die op het einde van het commando moeten bijgevoegd worden. Om het verschil te weten tussen deze 3 raad ik u aan deze commando’s uit te proberen en te vergelijk.
```PowerShell
> Get-Help Get-Help –detailed
> Get-Help Get-Help –full
> Get-Help Get-Help 
```
