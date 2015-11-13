## chapter 2: Introducing Windows Remote Management and CIM

### Windows Remote Management (WinRM)

- bgebaseerd op het Simple Object Acces Protocol (SOAP)
- deze service is gedisabled by default
- Checken van de status:
```
PS C:\> Get-Service -ComputerName WC81-1 -Name WinRM
```
- Starten van de Service en automatisch starten bij opstarten:
```
PS C:\> Set-Service -Name WinRM -ComputerName WC81-1 -StartupType Automatic -Status Running
```
 => creëert nog niet de nodige WinRM listeners for Remote system communication
 - Deze listeners zijn eindpunt die remote systems toegang verlenen om te verbinden
 - Deze creëren we via Modules

##### WS-Management Cmdlets

```
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