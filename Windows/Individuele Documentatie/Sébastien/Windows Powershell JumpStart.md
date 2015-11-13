# Windows Powershell JumpStart

### Chapter 1: Don't fear the shell
- Belangrijk om Powershell te runnen als administrator
- gebruik van Linux Commands, Windows Command of Commandlets
- belangrijke basis Cmdlets:
```
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
Get-Help *Process*
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

### Chapter 3: The pipeline: Getting connected
### Chapter 4: Extending the shell
### Chapter 5: Objects for the Admin
### Chapter 6: The pipeline: Deeper
### Chapter 7: The Power in the Shell - Remoting
### Chapter 8: Getting prepared for automation
### Chapter 9: Automation in scale - Remoting
### Chapter 10: Introducing scripting and toolmaking
