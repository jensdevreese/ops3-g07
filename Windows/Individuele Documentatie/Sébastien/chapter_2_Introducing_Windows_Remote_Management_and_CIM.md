## chapter 2: Introducing Windows Remote Management and CIM

### Windows Remote Management (WinRM)

- gebaseerd op het Simple Object Acces Protocol (SOAP)
- deze service is gedisabled by default
- Checken van de status:
```PowerShell
PS C:\> Get-Service -ComputerName WC81-1 -Name WinRM
```
- Starten van de Service en automatisch starten bij opstarten:
```PowerShell
PS C:\> Set-Service -Name WinRM -ComputerName WC81-1 -StartupType Automatic -Status Running
```
 => creëert nog niet de nodige WinRM listeners for Remote system communication
 - Deze listeners zijn eindpunt die remote systems toegang verlenen om te verbinden
 - Deze creëren we via Modules

##### WS-Management Cmdlets

```PowerShell
PS C:\>  Get-Command -Module Microsoft.WSMan.Management

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Connect-WSMan                                      3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Disable-WSManCredSSP                               3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Disconnect-WSMan                                   3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Enable-WSManCredSSP                                3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Get-WSManCredSSP                                   3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Get-WSManInstance                                  3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Invoke-WSManAction                                 3.0.0.0    Microsoft.WSMan.Management
Cmdlet          New-WSManInstance                                  3.0.0.0    Microsoft.WSMan.Management
Cmdlet          New-WSManSessionOption                             3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Remove-WSManInstance                               3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Set-WSManInstance                                  3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Set-WSManQuickConfig                               3.0.0.0    Microsoft.WSMan.Management
Cmdlet          Test-WSMan                                         3.0.0.0    Microsoft.WSMan.Management
```
- Nu kunnen we kijken of ons remote systeem WinRm geconfigureerd heeft
- We wien dat we WinRm Listeners moeten toestaan en zeker zijn dat WinRM klaar is om binnenkomende request te aanvaarden
- Dit wordt getest met:
```PowerShell
PS :\> Test-WSMan -ComputerName <Computer>
```
- We kunnen 2 type WinRM Listeners creëren: WinRM HTTP Listener (poort 5985) en WinRM HTTPS Listener (poort 5986) die SSL certificaten vereist

#### Creating a WinRM HTTP Listener
- Commandlet Set-WSManQuickConfig kunnen we gebruiken om zowel HTTP als HTTPS Listener te creëren
- Aangezien er geen ComputerName wordt meegegeven, moet dit uitgevoerd worden op het systeem waar we de Listener willen aanmaken
- We gebruiken Force om te voorkomen dat we prompt vermijden die om bevestiging vraagt
```PowerShell
PS C:\>Set-WSManQuickConfig -Force
WinRM is already set up to receive requests on this computer.
WinRM has been updated for remote management.
Created a WinRM listener on HTTP://* to accept WS-Man requests to any IP on this machine.
WinRM firewall exception enabled
```
- We zien dat WinRM service al runt en de HTTP listener gecreëerd is.
- We kunnen dit Testen met Test-Wsan en zien dan 

#### Creating a WinRM HTTPS Listener 
