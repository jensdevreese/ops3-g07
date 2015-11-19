# Verslag ciscolabo's

#Wat ging goed:
Het opzetten van het netwerk was geen probleem, op elke router de interfaces instellen is iets wat ik intussen wel kan zonder problemen.
Bij problemen bij het pingen daarna kon ik door naar de 'show running-config' te zien makkelijk de oorzaak (een foutief getypt ip vvoor R2) vinden.

#Wat ging niet goed:
ipv6 instellen was moeilijker, ik kreeg bij het proberen pingen naar andere devices constant de error: "% Unrecognized host or address or protocol not running."

Wat bleek was dat als je de 'ipv6 unicast-routing' uitvoerde na het netwerk op te zetten er nog niet met ipv6 gewerkt kon worden. Nadat ik hetzelfde netwerk nog eens opzette met eerst dit command waren er geen problemen.