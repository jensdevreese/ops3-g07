# Chapter 2: Getting Started with DSC
 - DSC is zeer afhankelijk van WinRM en CIM. Het is zeer belangrijk om eerst de architectuur ervan te kennen. In dit hoofdstuk wordet de DSC architectuur en zijn componenten besproken.

### DSC Configuration Management Architecture
 - de DSC configuratie management Architecture is redelijk eenvoudig. DSC en zijn componenten worden verspreid over verschillende fasen van configuration managment. Dit helpt niet alleen om de DSC architectuur beter te verstaan maar geeft ook een duidelijker beeld, welke rol is in welke fase van de 'configuration life cycle'.

 - in the overall architecture zijn er 2 fasen:
 		- Configuration Authoring and Staging
 		- Configuration Enacting

 #### Configuration Authoring and Staging