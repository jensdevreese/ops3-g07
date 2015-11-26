### The Configuration Management Challenge

- Typische configuration management cycle :
	- ... => Implement => Monitor & Report => Submit => Review => Approve => Implement ...
- Uitgebreide fases worden gebruikt om Configuratie aanpassingen uit te voeren
	- ... => Detect => Compare => Automate => Detect ...
 - Deze bevinden zich in de Monitor en report fase 
 - Detect en Compare zijn enorm belangrijk

 ### Understanding Desired State Configuration
  - = Configuration Management Feature ingebouwd in Windows
  - gebaseerd op standards-based management => incl. CIM en WS Remoting
  - offert een API aan en geen end-to-end tool set

 #### Imperative vs. Declarative syntax
  - Windows PowerShell is standaard imperative= >Als we een script schrijven, zeggen ze hoe Powershell een bepaalde taak moet uitvoeren
  - Belangrijk om exception handling in script te steken
  - In declarative stijl, vinden we het niet belangrijk hoe iets gedaan wordt. We zeggen wat er moet gebeuren en kijken dus niet hoe dat gaat gebeuren
  - deze stijl is makkelijker om te lezen en te verstaan
  - DSC voorziey aantal ingebouwde resources om configuratie van verschillende OS componenten te behern
  - DSC voorziet methodes omdie configuratie items te monitoren

 #### Enabling Desired State Configuration
 - DSC zit in WMF 4
 - standaard inbegrepen vanaf windows 8.1 en Server 2012 R2
 - kijken of laatste nieuwe update op systeem aanwezig is:
```PowerShell
PS C:\> Get-HotFix -Id KB2883200
```
#### Create WinRM Listener Using Group Policy
- GPMC feature moet geïnstalleerd zijn


 
