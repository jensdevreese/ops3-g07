# Chapter 2: Getting Started with DSC
 - DSC is zeer afhankelijk van WinRM en CIM. Het is zeer belangrijk om eerst de architectuur ervan te kennen. In dit hoofdstuk wordet de DSC architectuur en zijn componenten besproken.

## DSC Configuration Management Architecture
 - de DSC configuratie management Architecture is redelijk eenvoudig. DSC en zijn componenten worden verspreid over verschillende fasen van configuration managment. Dit helpt niet alleen om de DSC architectuur beter te verstaan maar geeft ook een duidelijker beeld, welke rol is in welke fase van de 'configuration life cycle'.

 - in the overall architecture zijn er 2 fasen:
 		- Configuration Authoring and Staging
 		- Configuration Enacting

![] (https://github.com/HoGentTIN/ops3-g07/blob/master/Windows/Individuele%20Documentatie/S%C3%A9bastien/Images/DSC_Architecture.PNG)

### Configuration Authoring and Staging
 - In deze eerst fase schrijven we de configuratie scripts die definiëren wat en hoe de resources moeten geconfigureerd worden en hoe de configuratie klaar wordt gezet voor enacting. Het zijn wel 2 aspecten maar aangezien de staging fase net na de authorign komt, kunnen deze perfect samen besproken worden. Hou in het achterhoofd dat het mogelijk is om een een configuratie MOF(Managed Object Format) te genereren zonder PowerShell.

#### Authoring
- De Configuration Authoring bevat Powershell Declarative Scripting. De language extension die we hiervoor gebruiken zijn een deel van de DSC Powershell Module. Om deze Language Extension te verstaan kijken we eerst naar een configuratie script. We gebruiken dit voorbeeld om door de verschillende DSC sleutelwoorden te gaan en de verschillende componenten in de Authoring fase.

```PowerShell
Configuration WebSiteConfig
{
	Node WSR2-1
	{
		WindowsFeature WebServer1
		{
			Name = "Web-Server"
		}

		WindowsFeature ASP
		{
		Name = "Web-Asp-Net45"
		}

		Website MyWebSite
		{
			Ensure = "Present"
			Name = "MyWebSite"
			PhysicalPath = "C:\Inetpub\MyWebSite"
			State = "Started"
			Protocol = @("http")
			BindingInfo = @("*:80:")
		}
	}
}
```
- Naarmate extra language extensions worden aangehaald zullen we dit script opbouwen, zodat duidelijk wordt hoe zo een script geschreven wordt en de detail van elk component duidelijk zijn

##### DSC PowerShell Modules
- Het eerste onderdeel da we bespreken zijn de DSC powershell Modules. De language extensions die we gebruiken in het script zijn geïmplementeerd in DSC powershell module. Met Get-Command kunnen we deze module verkennen. 
```PowerShell
PS C:\> Get-Command -Module PSDesiredStateConfiguration

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Configuration                                      1.1        PSDesiredStateConfiguration
Function        Disable-DscDebug                                   1.1        PSDesiredStateConfiguration
Function        Enable-DscDebug                                    1.1        PSDesiredStateConfiguration
Function        Find-DscResource                                   1.1        PSDesiredStateConfiguration
Function        Get-DscConfiguration                               1.1        PSDesiredStateConfiguration
Function        Get-DscConfigurationStatus                         1.1        PSDesiredStateConfiguration
Function        Get-DscLocalConfigurationManager                   1.1        PSDesiredStateConfiguration
Function        Get-DscResource                                    1.1        PSDesiredStateConfiguration
Function        New-DscChecksum                                    1.1        PSDesiredStateConfiguration
Function        Remove-DscConfigurationDocument                    1.1        PSDesiredStateConfiguration
Function        Restore-DscConfiguration                           1.1        PSDesiredStateConfiguration
Function        Stop-DscConfiguration                              1.1        PSDesiredStateConfiguration
Cmdlet          Invoke-DscResource                                 1.1        PSDesiredStateConfiguration
Cmdlet          Publish-DscConfiguration                           1.1        PSDesiredStateConfiguration
Cmdlet          Set-DscLocalConfigurationManager                   1.1        PSDesiredStateConfiguration
Cmdlet          Start-DscConfiguration                             1.1        PSDesiredStateConfiguration
Cmdlet          Test-DscConfiguration                              1.1        PSDesiredStateConfiguration
Cmdlet          Update-DscConfiguration                            1.1        PSDesiredStateConfiguration
```

###### Configuration Keyword
- Het eerste woord dat we tegenkomen in het script is het woord configuration. Dit is de kern component van DSC, aangezien deze gewenste configuratie van een systeem definieert. Deze wordt gevolgd door een naam en vervolgens een scriptblok.
```PowerShell
Configuration IdentifierString{
	
}
```
- Wanneer we deze code in Powershell ISE runnen, wordt het configuratie commando in de huidige powershell session geladen. Met Get-Command kan je dan commando's verkennen die van het type 'Configuration' zijn. Het Configuration commandType is pas toegevoegd in WMF 4.0 om DSC configuraties toe te staan. Interessant om te weten is dat een aantal parameters standaard gecreëerd worden. Je kan zien welke 'Configuration' automatisch toevoegd.
```PowerShell
PS C:\> Get-Command -CommandType Configuration

CommandType     Name                                               ModuleName  
-----------     ----                                               ----------  
Configuration   IdentifierString                                               



PS C:\> Get-Command -CommandType Configuration | select -ExpandProperty Parameters

Key                                     Value                                  
---                                     -----                                  
InstanceName                            System.Management.Automation.Paramet...
OutputPath                              System.Management.Automation.Paramet...
ConfigurationData                       System.Management.Automation.Paramet...
```
- Ondanks dat Configuration de kern is van DSC, is deze toch zinloos als we die niet opvullen met ander Keywords en Componenten

###### Node Keyword

- In de Node zeggen we welke bestemmingsystemen we willen aanspreken voor onze configuratie. Node wordt ook weer gevolgd door een naam en vervolgens een scriptblok.
```PowerShell
Configuration IdentifierString{
	Node TargetSystemName {
	}
}
```

##### DSC Resources
- De configuratie die we moeten beheren moet gespecifieerd worden als een resource script blok. een resource identificeerd en enititeit die beheerd kan wordne met een configuration script. Elke beheerbare resource moet een gelinkte DSC Resource Module hebben. Deze zort namelijk voor het 'Hoe'-gedeelte van de configuration management. Ze zijn geschreven in Imperatieve stijl, wat will zeggen dat ze alle nodige details implementeren die nodig zijn om confugartie-instellingen te beheren.
- We kunnen alle mogelijke DSCResources als volgt ophalen
```PowerShell
PS C:\> Get-DscResource

ImplementedAs   Name                      Module                         Properties                               
-------------   ----                      ------                         ----------                               
PowerShell      Archive                   PSDesiredStateConfiguration    {Destination, Path, Checksum, DependsO...
PowerShell      Environment               PSDesiredStateConfiguration    {Name, DependsOn, Ensure, Path...}       
Binary          File                                                     {DestinationPath, Attributes, Checksum...
PowerShell      Group                     PSDesiredStateConfiguration    {GroupName, Credential, DependsOn, Des...
Composite       IdentifierString                                         {}                                       
Binary          Log                       PSDesiredStateConfiguration    {Message, DependsOn}                     
PowerShell      Package                   PSDesiredStateConfiguration    {Name, Path, ProductId, Arguments...}    
PowerShell      Registry                  PSDesiredStateConfiguration    {Key, ValueName, DependsOn, Ensure...}   
PowerShell      Script                    PSDesiredStateConfiguration    {GetScript, SetScript, TestScript, Cre...
PowerShell      Service                   PSDesiredStateConfiguration    {Name, BuiltInAccount, Credential, Dep...
PowerShell      User                      PSDesiredStateConfiguration    {UserName, DependsOn, Description, Dis...
PowerShell      WindowsFeature            PSDesiredStateConfiguration    {Name, Credential, DependsOn, Ensure...} 
PowerShell      WindowsProcess            PSDesiredStateConfiguration    {Arguments, Path, Credential, DependsO...
```
- DSC voorziet een methode om eigen DSCResources te creëren. Deze resources zijn geschreven als PowerShell Modules en er wordt naar verwezen als custom DSC Resources. Dit wordt later nog in het boek besproken.

##### Ons eerste Configuratie Script
- de Name Property van de resource wordt een dynamisch keyword. de PSDesiredStateConfiguration module zorgt voor het laden van al deze dynamische keywords. In Powershell ISE worden deze met de Tab toets zelf automatisch aangevuld. 
- Nu we verder ons script beginnen opvullen is het handig om te weten hoe de syntax er uit ziet van een bepaalde resource om zo te weten wat nodig is om de resource in een configuratie script te gebruiken. Dit kan op volgende manier
```PowerShell
PS C:\> Get-DscResource -Name WindowsFeature -Syntax
WindowsFeature [String] #ResourceName
{
    Name = [string]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [IncludeAllSubFeature = [bool]]
    [LogPath = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [Source = [string]]
}
```
- De [] regels zijn hetzelfde als bij de Commandlets dus hier zien we dat enkel de Name verplicht is. Met deze informatie kunnen we dus verder naar ons configuratie script
```PowerShell
Configuration WebsiteConfig {
	Node WSR2-1 
	{
		WindowsFeature WebServer1 
		{
			Name = "Web-Server"
			DependsOn = "[WindowsFeature]ASP"
		}
<#
		WindowsFeature WebServer2 
		{
			Name = "Web-Server"
		}
#>
		WindowsFeature ASP 
		{
			Name = "Web-Asp-Net45"
		}
	}
}
```
- We willen dus WindowsFeatures toepassen, dus moeten we de verplichte parameters zeker meegeven. Default wordt de Ensure property gezet op Present, dus deze moeten we niet aanpassen. Het is heel belangrijk om rekening te houden met het feit dat de naam van de WindowsFeature Uniek moet zijn. We kunnen dus niet bijvoorbeeld WebServer1 en Webserver2 toevoegen als hun Name Property dezelfde waarde krijgt. We kunnen wel beide de Web-Server role als Web-ASP-Net45 configureren.
- We kunnen bovendien wanneer we meerdere resources in een node block gebruiken, deze afhankelijk laten zijn van elkaar. Zo weten we wat eerst moet geconfigureerd worden. Hier zal dus eerste de Web-ASP-Net45 feature eerst moeten geïnstalleerd worden.
- Dit configuratie script doet nog geen aanpassingen aan het systeem. Het toont enkel welke veranderingen we zouden willen maken. Nu moeten we dit vertalen zodat de DSC Local Configuration Manager of de DSC Engine dit kunnen verstaan. Dit wordt dan de MOF representatie van het configuratie script. We kunnen dit genereren door onderaan de naam van de configuratie toe te voegen en als een ps1 bestand op te slaan
```PowerShell
PS C:\scripts> .\WebsiteConfig.ps1


    Directory: C:\scripts\WebsiteConfig


Mode                LastWriteTime     Length Name                                                                 
----                -------------     ------ ----                                                                 
-a---         8/12/2015      0:02       1756 WSR2-1.mof                                                           
```
- Het is niet noodzakelijk om het script op te slaan. Het runnen in ISE volstaat ook. Je ziet dus dat er een map wordt aangemaakt en daarin het MOF bestand geplaatst wordt. Het gegenereerde MOF bestand ziet er als volgt uit:
```PowerShell
/*
@TargetNode='WSR2-1'
@GeneratedBy=Administrator
@GenerationDate=12/08/2015 00:02:55
@GenerationHost=WIN-IHRF85AA35L
*/

instance of MSFT_RoleResource as $MSFT_RoleResource1ref
{
ResourceID = "[WindowsFeature]WebServer1";
 DependsOn = {
    "[WindowsFeature]ASP"
};
 SourceInfo = "C:\\scripts\\WebsiteConfig.ps1::4::3::WindowsFeature";
 Name = "Web-Server";
 ModuleName = "MSFT_RoleResource";
 ModuleVersion = "1.0";

};

instance of MSFT_RoleResource as $MSFT_RoleResource2ref
{
ResourceID = "[WindowsFeature]ASP";
 SourceInfo = "C:\\scripts\\WebsiteConfig.ps1::10::3::WindowsFeature";
 Name = "Web-Asp-Net45";
 ModuleName = "MSFT_RoleResource";
 ModuleVersion = "1.0";

};

instance of OMI_ConfigurationDocument
{
 Version="1.0.0";
 Author="Administrator";
 GenerationDate="12/08/2015 00:02:55";
 GenerationHost="WIN-IHRF85AA35L";
};
```
- Voor elke WindowsFeature Resource zien een entry specifiek als de instantie van MSFT_RoleResource klasse. Voor elke Resource in het configuratiescript, zal de MOF de instantie van de te implementeren klasse van dezelfde resource bevatten. Je kan het MOF bestand op een andere plaats opslaan door de parameter -OutputPath te gebruiken op het einde van het script.
´´´PowerShell
Configuration WebsiteConfig{}
WebsiteConfig -OutputPath c:\DSCMOFS
```

##### Requirements for configuration Authoring
- We weten dat er een aantal vereisten zijn om met Language Extensions te werken in PowerShell en om configuratiescripts te authoren en MOF objecten te genereren. Bovendien moeten ook alle DSCResources gedownload zijn. Belangrijk om te onthouden in DSC is dat eenmaal een MOF gegenereerd is, we het Configuratiecript niet meer nodig hebben tot we er wijzigingen in willen aanbrengen en dan weer een nieuwe MOF maken. Het is van essentieel belang dat dit MOF bestand op een toegankelijke plaats staat op het systeem. Dit noemen we 'Configuration Staging'. De locatie hangt af van hoe we plannen om de configuratie af te leveren. Dit verwijst naar hoe het bestemmingsysteem de MOF ontvangt voor enacting.

###### Staging and Delivery
- Dit is het natuurlijke gevolg achter authoring. Hierbij gebruikten we het Configuration keyword and genereerde we ene MOF representatie van de aanpassingen die moeten gebeuren. Je kan dit MOF bestand ook opslaan op een andere server mits je daar permissies voor hebt. Dit is vooral handig Wanneer er gewerkt wordt met een centrale locatie waar  "version-control" gebruikt wordt. Dankzij "Version Control" kan je altijd naar een vorige situatie gaan van de configuratie. Hier hebben we Het MOF bestand opgeslaan op een netwerklocatie maar dit alleen is niet voldoende. Het MOF bestand moet eerst toekomen op het Systeem en kan dan pas enacten. DSC ondersteunten 2 methodes van configuratie levering: PUSH en PULL.

##### Push Mode



##### Pull mode



### Configuration Enacting

 - Hier wordt de configuratie toegepast op het Systeem. Er zijn 2 modes namelijk Push en Pull, waardoor we de configuratie kunnen doorvoeren voor enacting. Enacting verwijst naar het ontvangen van de configuratie MOF en het uitvoeren van de vereiste configuratie veranderingen.
