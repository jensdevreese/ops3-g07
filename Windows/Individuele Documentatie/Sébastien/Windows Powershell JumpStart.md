# Windows Powershell JumpStart

### Chapter 1: Don't fear the shell

- Belangrijk om Powershell te runnen als administrator
- gebruik van Linux Commands, Windows Command of Commandlets
- belangrijke basis Cmdlets:
```PowerShell
PS C:\> Clear-Host			(cls)
PS C:\> Set-Location		(cd)
PS C:\> Get-Childitem		(dir, ls)
PS C:\> Get-Content			(type, cat)
PS C:\> copy-item			(copy, cp)

```

### Chapter 2: The Help system

- Regelmatig update-help uitvoeren om laatste nieuwe update te hebben
##### Get-Help vs Help vs Man
- Help <cmdlet>
- Help *partial*
- Help <verb/noun>
- Help <cmdlet> -Full
- Help <cmdlet> -Online
- Help <cmdlet> -ShowWindow (opent een apart venster)
```PowerShell
PS C:\> Get-Help *Process*
Name                              Category  Module                    Synopsis
----                              --------  ------                    --------
Enter-PSHostProcess               Cmdlet    Microsoft.PowerShell.Core Connects to and enters into an interactive ...
Exit-PSHostProcess                Cmdlet    Microsoft.PowerShell.Core Closes an interactive session with a local ...
Get-PSHostProcessInfo             Cmdlet    Microsoft.PowerShell.Core
Debug-Process                     Cmdlet    Microsoft.PowerShell.M... Debugs one or more processes running on the...
Get-Process                       Cmdlet    Microsoft.PowerShell.M... Gets the processes that are running on the ...
Start-Process                     Cmdlet    Microsoft.PowerShell.M... Starts one or more processes on the local c...
Stop-Process                      Cmdlet    Microsoft.PowerShell.M... Stops one or more running processes.
Wait-Process                      Cmdlet    Microsoft.PowerShell.M... Waits for the processes to be stopped befor...

```
##### Syntax

- Parameter Sets
```
SYNTAX
    Get-ChildItem [[-Path] <String[]>] [[-Filter] <String>] [-Exclude <String[]>] [-Force] [-Include <String[]>] [-N
    ame] [-Recurse] [-UseTransaction [<SwitchParameter>]] [<CommonParameters>]

    Get-ChildItem [[-Filter] <String>] [-Exclude <String[]>] [-Force] [-Include <String[]>] [-Name] [-Recurse] -Lite
    ralPath <String[]> [-UseTransaction [<SwitchParameter>]] [<CommonParameters>]
```
- Betekenis Parameters
    - wijst op parameter: -
    - wijst op argumenten: <>
    - argumenten met meerdere waarden: []
    - is positioneel: [Param]
    - is optioneel: [Param Arg]

### Chapter 3: The pipeline: Getting connected

- Pipeline symbool: |
```Powershell
PS C:\> Get-Service | Select-Object name, status | Sort-Object name

Name                                      Status
----                                      ------
AdobeARMservice                          Running
AJRouter                                 Stopped
ALG                                      Stopped
AppIDSvc                                 Stopped
Appinfo                                  Running
Apple Mobile Device Service              Running
AppMgmt                                  Stopped
AppReadiness                             Stopped
...
```
##### Exporteren en Importeren 

- CSV
```Powershell
PS C:\> Get-Process | export-csv c:\porc.csv
PS C:\> notepad c:\proc.csv
PS C:\> import-csv c:\porc.csv
```
- XML
```PowerShell
PS C:\> Get-Process | Export-clixml c:\ref.xml
```
- andere bestanden en printers
```PowerShell
PS C:\> Get-Service > c:\serv.txt
PS C:\> Get-Service | Out-File c:\serv2.txt
PS C:\> Get-Service | Out-Printer
```
- Informatie in GUI tonen
```PowerShell
PS C:\> Get-Service | Out-GridView
```
- Webpagina met informatie maken
- kan met ConvertTo-Csv en ConvertTo-Html
```PowerShell
PS C:\> Get-Service | ConvertTo-Html -Property DisplayName, status |
>> Out-File c:\serv.htm
>>
```
##### Cmdlets that kill
- Stop-Process / kill
- Stop-service
- extra opties: -Confirm 		-Whatif

### Chapter 4: Extending the shell
- Modules
```PowerShell
PS C:\> Get-Module -ListAvailable
ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Manifest   1.0.0.0    AppBackgroundTask                   {Disable-AppBackgroundTaskDiagnosticLog, Enable-AppBack...
Manifest   2.0.0.0    AppLocker                           {Get-AppLockerFileInformation, Get-AppLockerPolicy, New...
Manifest   2.0.0.0    Appx                                {Add-AppxPackage, Get-AppxPackage, Get-AppxPackageManif...
Script     1.0.0.0    AssignedAccess                      {Clear-AssignedAccess, Get-AssignedAccess, Set-Assigned...
Manifest   1.0.0.0    BitLocker                           {Unlock-BitLocker, Suspend-BitLocker, Resume-BitLocker,...
Manifest   2.0.0.0    BitsTransfer                        {Add-BitsFile, Complete-BitsTransfer, Get-BitsTransfer,...
Manifest   1.0.0.0    BranchCache                         {Add-BCDataCacheExtension, Clear-BCCache, Disable-BC, D...
...

PS C:\> Import-Module act*

```
- Snap-in
```PowerShell
PS C:\> Get-PSSnapin -Registered

PS C:\> Add-PSSnapin sql*
```

### Chapter 5: Objects for the Admin

- Informatie verkrijgen die je wil:
```PowerShell
PS C:\> Get-Process | Get-Member


   TypeName: System.Diagnostics.Process

Name                       MemberType     Definition
----                       ----------     ----------
Handles                    AliasProperty  Handles = Handlecount
Name                       AliasProperty  Name = ProcessName
NPM                        AliasProperty  NPM = NonpagedSystemMemorySize64
PM                         AliasProperty  PM = PagedMemorySize64
VM                         AliasProperty  VM = VirtualMemorySize64
WS                         AliasProperty  WS = WorkingSet64
Disposed                   Event          System.EventHandler Disposed(System.Object, System.EventArgs)
ErrorDataReceived          Event          System.Diagnostics.DataReceivedEventHandler ErrorDataReceived(System.Obj
Exited                     Event          System.EventHandler Exited(System.Object, System.EventArgs)
OutputDataReceived         Event          System.Diagnostics.DataReceivedEventHandler OutputDataReceived(System.Ob
BeginErrorReadLine         Method         void BeginErrorReadLine()
...
```
- TypeName is een unieke naam door windows toegekent
- Toont de eigenschappen en methodes van een object
- Properties zijn potentiÃ«le kolommen met informatie
- Methodes zijn mogelijke acties die genomen kunnen worden

- Via Sort-Object kan je sorteren op -Property met als optie -Descending (indien dalende volgorde)
- Select-Object selecteert properties van een object
- met -first en -last wordt er een beperking opgelegt voor de getoonde rijen

##### Custom Properties

```PowerShell
PS C:\> Get-WmiObject win32_logicalDisk -Filter "deviceID='c:'" |
>>> Select-Object -Property __Server,
>>> @{n='FreeGB';e={$_.Freespace /1Gb -as [int]}} |
>>> Format-Table -AutoSize

__SERVER        FreeGB
--------        ------
DESKTOP-BGT0PSQ     16

```
##### Filter Object Out of the Pipeline
```PowerShell
PS C:\> Get-Service | Where-Object -FilterScript {$_.status -eq 'running'}
zelfde als:
PS C:\> gsv | ?{$_.status -eq 'Running'}

Status   Name               DisplayName
------   ----               -----------
Running  AdobeARMservice    Adobe Acrobat Update Service
Running  Appinfo            Application Information
Running  Apple Mobile De... Apple Mobile Device Service
Running  AudioEndpointBu... Windows Audio Endpoint Builder
Running  Audiosrv           Windows Audio
Running  AVGIDSAgent        AVGIDSAgent
Running  avgwd              AVG WatchDog
Running  BFE                Base Filtering Engine
Running  BITS               Background Intelligent Transfer Ser...
...
```
##### Vergelijkingsoperatoren

- returnen True of False
- Bij gebruik van -ceq ipv -eq dan is het case sensitive
- voor meer uitleg:
```PowerShell
PS C:\> Get-Help About_Comparison_Operators
```

### Chapter 6: The pipeline: Deeper

#### ByValue en ByPropertyName

###### ByValue

```PowerShell
PS C:\> Get-Service bits | gm

  TypeName: System.ServiceProcess.ServiceController
```
 - Get-Service passeert ServiceController objects naar de pipeline
 - Kijken of Stop-Service, objecten van ServiceController aanvaard
 - Help Stop-Service -Full toont een parameter die ServiceController aanvaard ByValue
```PowerShell
PS c:\> get-service bits | stop-service

Help page stop-service:

 -InputObject <ServiceController[]>
     Specifies ServiceController objects representing the services to be stopped. Enter a variable that contains the
      objects, or type a command or expression that gets the objects.

     Required?                    true
     Position?                    1
     Default value                none
     Accept pipeline input?       True (ByValue)
     Accept wildcard characters?  false

```
###### ByPropertyName

- Get-Process returnt een process
- We zien dat stop-service geen processen aanvaard als object ByValue (help stop-service)
```PowerShell
PS C:\> Get-Process | Get-Member -MemberType Properties


   TypeName: System.Diagnostics.Process

Name                       MemberType     Definition
----                       ----------     ----------
Handles                    AliasProperty  Handles = Handlecount
Name                       AliasProperty  Name = ProcessName
NPM                        AliasProperty  NPM = NonpagedSystemMemorySize64
PM                         AliasProperty  PM = PagedMemorySize64
VM                         AliasProperty  VM = VirtualMemorySize64
WS                         AliasProperty  WS = WorkingSet64
__NounName                 NoteProperty   string __NounName=Process
BasePriority               Property       int BasePriority {get;}
Container                  Property       System.ComponentModel.IContainer Container {get;}
EnableRaisingEvents        Property       bool EnableRaisingEvents {get;set;}
...
```
- -Name aanvaard wel strings ByPropertyName and de objecten zijn gelabeled als Name Property
- Stop-service failed aangezien er processen op naam worden doorgegeven, en deze geen services zijn
```PowerShell
PS C:\> Get-Process -Name no* | stop-service
```
###### The Parenthetical - als het faalt
- Een lijst met Computernamen (als txt) doorgeven aan Get-Service zal niet lukken
```PowerShell
PS S:\> Get-Content c:\names.txt | Get-Service
```
- -Name en -InputObject aanvaarden pipeline input ByValue, niet -computerName
- -Name aanvaard text en dat zorgt voor de fout
```PowerShell
PS C:\> Get-Service -ComputerName (Get-Content c:\names.txt)
```
- Ander voorbeeld return hier een collection(table) van objecten
- Oplossing returnt string contents
```PowerShell
PS C:\> Get-Service -ComputerName (Get-ADComputer -Filter* |
>> Select -ExpandProperty Name)
>>
```
### Chapter 7: The Power in the Shell - Remoting
##### Remoting
- Heel belangrijk dat Remoting enabled wordt
- Standaard enabled in Windows Server 2012
```PowerShell
PS C:\> Enable-PSRemoting

WinRM Quick Configuration
Running command "Set-WSManQuickConfig" to enable remote management of this computer by using the Windows Remote
Management (WinRM) service.
 This includes:
    1. Starting or restarting (if already started) the WinRM service
    2. Setting the WinRM service startup type to Automatic
    3. Creating a listener to accept requests on any IP address
    4. Enabling Windows Firewall inbound rule exceptions for WS-Management traffic (for http only).

Do you want to continue?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"): y
```
###### 1 op 1
- Inloggen op Computer van op afstand
- Tonen van vb de services op Server1 
```PowerShell
PS C:\> Enter-PSSesion Server1
[Server1]: PS C:\> Get-Service
```
###### 1 op veel
```PowerShell
PS C:\> Invoke-Command -ComputerName Server1, Server2 -ScriptBlock {
>> Get-EventLog -LogName Security -Newest 2}
>>
```
- Nu zullen de 2 laatste 2 security logs van Server1 en Server 2 getoond worden
###### Powershell Web Acces
- Mogelijkheid om vanop elk device via browser, toegang te hebben tot machine
- Install-WindowsFeature -Name WindowsPowerShellWebAccess
- Install-PswaWebApplication -UseTestCertificate (testen... 90 dagen geldig)
- Add-PswaAuthorizationRule -userName <Domain\User | Computer\User> -ComputerName <Computer> -ConfigurationName AdminsOnly

### Chapter 8: Getting prepared for automation
- Powershell is default beveiligd
- Voorkomt fouten die per ongeluk zouden gemaakt kunnen worden door Admins en Gebruikers
- Om script uit te voeren moet padnaam getypd worden
- Scripts hebben als extensie .ps1
- Standaard runt PowerShell geen scripts => Execution policy is default restricted
- In Group Policy kan dit aangepast worden
  - Unrestriced (alle scripts kunnen uitgevoerd worden)
  - AllSigned (Enkel scripts die ondertekent zijn door betrouwbare uitgever, kunnen uitgevoerd worden)
  - RemoteSigned (Gedownloade Scripts moeten eerst ondertekent worden voor deze worden uitgevoerd)
  - Bypass ( niets is geblokkeerd en er zijn geen waarschuwingen of prompts)

##### Scripts
- $ om variabele te creëren
 ```PowerShell
$mijnVariabele
 ```
- Types kunnen niet geforceerd worden
- Mogelijkheid om Set en Get-Variable te gebruiken
- verschillende quotes geven andere uitkomst
      - " dubbele quotes lossen alle variabelen op"
      - 'Enkele quotes voorkomen substitutie'
      - Meer info op Get-Help About_Quoting_Rules

- Input op het scherm tonen
```PowerShell
PS C:\> Write-Host "Powershell" -ForegroundColor Yellow -BackgroundColor Red

of met pipeline

PS C:\> Write-Host "Hello" | Where-object {$_.length -gt 10}
Hello
```
- Write-Warning , Write-Verbose, Write-Debug, Write-Error hebben elk eigen opmaak en zullen anders weergegeven worden

### Chapter 9: Automation in scale - Remoting
- Sessions kunnen hergebruikt worden door session op te slaan als variabele
```PowerShell
PS C:\> $session=New-PSSession -ComputerName Server1, Server2
PS C:\> Invoke-Command -Session $session {Import-Module ServerManager}
```
- Elke keer dat $session wordt opgeroepen zullen alle aanpassingen op zowel Server 1 als Server 2 gebruiken

### Chapter 10: Introducing scripting and toolmaking
- Maak Gebruik van Administrator: Windows PowerShell ISE
- Handig Scripts aanpassen / maken en veranderen naar gewone powershell om uit te voeren van scripts gemakkelijker te maken

###### Hoe een script er uit moet zien
```PowerShell
<#
.Synopsis
Hier komt de huidige disk grootte en beschikbare ruimte //korte beschrijving
.Description
Hier komt een lange beschrijving
.Parameter ComputerName
Dit is de Computer waarvan de DiskInfo wordt gehaald
.Example
PS C:\> .\Script.ps1 -ComputerName <Computer>
ophalen van de diskInfo van de remote Computer.
#>
Function Get-DiskInfo{
  
  [CmdletBinding()]

  Param(
      [Parameter(Mandatory=$true)]
      $ComputerName='localhost'
  )

  $Disk=Get-WmiObject -Class win32_LogicalDisk -Filter "DeviceID='c:'" -ComputerName $ComputerName

  $Property=@{
        'Computer'= $ComputerName;
        'TotalSpace'= $Disk.size / 1gb -as [int];
        'FreeSpace'= $Disk.freespace /1 gb -as [int]}


  $obj=New-Object -TypeName PSObject -Property $Property
  Write-Output $Obj
}
```
- Mogelijkheid om scripts weg te schrijven naar een Module
- Daarna kunnen modules geïmporteerd worden
- Opslaan als .psm1 bestand
```PowerShell
Function Set-DiskInfp{}
Function Remove-DiskInfo {}
Function Get-DiskInfo{
  
  [CmdletBinding()]

  Param(
      [Parameter(Mandatory=$true)]
      $ComputerName='localhost'
  )

  $Disk=Get-WmiObject -Class win32_LogicalDisk -Filter "DeviceID='c:'" -ComputerName $ComputerName

  $Property=@{
        'Computer'= $ComputerName;
        'TotalSpace'= $Disk.size / 1gb -as [int];
        'FreeSpace'= $Disk.freespace /1 gb -as [int]}


  $obj=New-Object -TypeName PSObject -Property $Property
  Write-Output $Obj
}
```
- Wanneer deze module geïmporteerd wordt dan kunnen de functies gebruikt worden wonder dat de scripts uitgevoerd moeten worden

