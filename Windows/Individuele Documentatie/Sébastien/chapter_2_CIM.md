### Common Information Model (CIM)
 - CIM standard definieert hoe IT-elementen beheert moeten worden en hoe deze worden voorgesteld.

 ##### Introduction to CIM Cmdlets
 ```PowerShell
PS C:\> Get-Command -Module CimCmdlets

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Export-BinaryMiLog                                 1.0.0.0    CimCmdlets
Cmdlet          Get-CimAssociatedInstance                          1.0.0.0    CimCmdlets
Cmdlet          Get-CimClass                                       1.0.0.0    CimCmdlets
Cmdlet          Get-CimInstance                                    1.0.0.0    CimCmdlets
Cmdlet          Get-CimSession                                     1.0.0.0    CimCmdlets
Cmdlet          Import-BinaryMiLog                                 1.0.0.0    CimCmdlets
Cmdlet          Invoke-CimMethod                                   1.0.0.0    CimCmdlets
Cmdlet          New-CimInstance                                    1.0.0.0    CimCmdlets
Cmdlet          New-CimSession                                     1.0.0.0    CimCmdlets
Cmdlet          New-CimSessionOption                               1.0.0.0    CimCmdlets
Cmdlet          Register-CimIndicationEvent                        1.0.0.0    CimCmdlets
Cmdlet          Remove-CimInstance                                 1.0.0.0    CimCmdlets
Cmdlet          Remove-CimSession                                  1.0.0.0    CimCmdlets
Cmdlet          Set-CimInstance                                    1.0.0.0    CimCmdlets
 ```
  - CimCmdlets zorgen voor:
  	- Informatie van CIM klassen te verkijgen
  	- Creëren, verwijderen en veranderen van eigenschappen van CIM instanties en associaties
  	- Creëren en beheren van CIM sessies
  	- oproepen van CIM methodes
  	- Registreren en beantwoorden naar CIM indicatie events

 #### Exploring CIM Classes and Instances
 - DMTF CIM heeft 2 belangrijke delen: CIM schema(1) en CIM infrastructuur specificatie(2)
 - 1) voorziet modelbeschrijving , gestructureerde managementomgeving met collectie van klassen met eigenschappen en methodes
 - 2) definieert het conceptuele aspect van de beheerde omgeving en de standaarden om meerdere management models te integreren

 - We gebruiken Get-CimClass om een lijst van CimClasses te krijgen in een specifieke namespace
 - Wanneer er geen argumenten zijn, zoekt deze deafult in root\cimv2
 ```PowerShell
PS C:\> Get-CimClass -Namespace root\wmi -ClassName Win32*

   NameSpace: ROOT/wmi

CimClassName                        CimClassMethods      CimClassProperties
------------                        ---------------      ------------------
Win32_PrivilegesStatus              {}                   {StatusCode, Description, Operation, ParameterInfo...}
Win32_Perf                          {}                   {Caption, Description, Name, Frequency_Object...}
Win32_PerfRawData                   {}                   {Caption, Description, Name, Frequency_Object...}
Win32_PerfFormattedData             {}                   {Caption, Description, Name, Frequency_Object...}
 ```
 - -ClassName wordt gebruikt om name van argument te specifiëren
 - Dit (gebruik van wildcards) lukt niet bij Get-CimInstance => wordt geholpen door middel van -Filter
 - Vergeet niet dat sommige CIM klassen, adminrechten vereisen!
 - elke CIM Namespace is een instantie van _NAMESPACE class (system class begint met een __)
 ```Powershell
 PS C:\> Get-CimInstance -Class __NAMESPACE -Namespace root | select Name

Met -Filter om een lijst met instanties te krijgen die aan een specifieke criteria voldoen
PS C:\> Get-CimInstance -ClassName Win32_Process -Filter "Name='chrome.exe'"

ProcessId Name       HandleCount WorkingSetSize VirtualSize
--------- ----       ----------- -------------- -----------
5364      chrome.exe 1402        123703296      504676352
9452      chrome.exe 378         39346176       264151040
4248      chrome.exe 220         95756288       295682048
10096     chrome.exe 339         266682368      643973120
11800     chrome.exe 238         89792512       292306944
5644      chrome.exe 277         61607936       327544832
 ```
 - Op deze manier kan je een namespace vinden als je de naam niet weet

 #### WMI Query Language
 
 - onderdeel van de ANSI-SQL met set van sleutelwoorden en operators en ondersteunt 3 types van queries: data, event en schema queries

 ##### WQL Keywords
 - net zoals bij sql, worden wql sleutelwoorden gebruikt om data op te halen. Er zijn er 19
![screenshot WQL1] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Windows/Individuele%20Documentatie/S%C3%A9bastien/Images/WQL_Keywords_1.PNG?token=AGfNEisTDyS64H3d5LG6qpMsvxtYiRPAks5WXDrVwA%3D%3D)
![screenshot WQL2] (https://raw.githubusercontent.com/HoGentTIN/ops3-g07/master/Windows/Individuele%20Documentatie/S%C3%A9bastien/Images/WQL_Keywords_2.PNG?token=AGfNEqvCDrDMkYD-jlTWfCx47VGqWjHDks5WXDrnwA%3D%3D)

##### WQL Operators
 - redelijk gelijkaardig aan andere operatoren: "=,>,<,>=,<=,<> of !="
 - sommige WQL Sleutelwoorden kunnen ook als operator gebruikt worden

##### WQL queries schrijven
- Voorbeeld van een data query
```PowerShell
PS C:\>Get-CimInstance -Query "SELECT * FROM Win32_Process WHERE (Name='Chrome.exe' OR Name='iexplore.exe') AND HandleCount > 150"

ProcessId Name       HandleCount WorkingSetSize VirtualSize
--------- ----       ----------- -------------- -----------
10428     chrome.exe 1106        100102144      481574912
9864      chrome.exe 256         31076352       237023232
9648      chrome.exe 219         100433920      289779712
9548      chrome.exe 289         94105600       392355840

```
 - hier selecteren we alles van chrome of iexplore processen in Win32_Process, je kan * ook vernaderen door wat je wil te zien krijgen
 - gebruik van Reguliere Expressies kan door LIKE '[A-C]hrome%' toe te voegen
 - Bij AND en OR moeten haakjes gezet worden
 - In CIM standaard specificatie, worden events voorgesteld als indicaties, kan gedefinieerd worden als een verandering van status
 - Vb van play naar pause gaan => Elke staat is stelt een event voor
 - Mogelijkheid om te abonneren op CIM indicaties 
```PowerShell
PS C:\> Register-CimIndicationEvent -ClassName Win32_ProcessStartTrace -Action {
>>> Write-Host "A new process started"
>>> }

Id     Name            PSJobTypeName   State         HasMoreData     Location             Command
--     ----            -------------   -----         -----------     --------             -------
3      e09443c7-71f...                 NotStarted    False                                ...

PS C:\> A new process started
A new process started
A new process started
```








