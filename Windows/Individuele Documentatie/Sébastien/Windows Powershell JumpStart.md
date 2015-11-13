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
-Betekenis Parameters
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

-CSV
```Powershell
PS C:\> Get-Process | export-csv c:\porc.csv
PS C:\> notepad c:\proc.csv
PS C:\> import-csv c:\porc.csv
```
-XML
```PowerShell
PS C:\> Get-Process | Export-clixml c:\ref.xml
```
-andere bestanden en printers
```PowerShell
PS C:\> Get-Service > c:\serv.txt
PS C:\> Get-Service | Out-File c:\serv2.txt
PS C:\> Get-Service | Out-Printer
```
-Informatie in GUI tonen
```PowerShell
PS C:\> Get-Service | Out-GridView
```
-Webpagina met informatie maken
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
- Properties zijn potentiële kolommen met informatie
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
### Chapter 8: Getting prepared for automation
### Chapter 9: Automation in scale - Remoting
### Chapter 10: Introducing scripting and toolmaking
