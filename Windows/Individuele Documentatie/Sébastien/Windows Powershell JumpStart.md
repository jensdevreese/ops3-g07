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

### Chapter 4: Extending the shell
### Chapter 5: Objects for the Admin
### Chapter 6: The pipeline: Deeper
### Chapter 7: The Power in the Shell - Remoting
### Chapter 8: Getting prepared for automation
### Chapter 9: Automation in scale - Remoting
### Chapter 10: Introducing scripting and toolmaking
