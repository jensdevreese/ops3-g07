## Laboverslag: 

- Naam cursist: Jens De Vreese
- Bitbucket repo: https://bitbucket.org/JensDeVreese93/enterprise-linx-labo

### Procedures

1. De eerste stap is de 3 rollen toegevoegen  (Mariadb,Wordpress en httpd). Deze komen uit de githubrepository van bertvv.
2. in de site.yml-file van onze host, hebben we naar deze 3 rollen verwezen.
3. vervolgens hebben we dependencies.yml gecreeert met daarin de volgorde van de roles.
4. pu004 moet de webhost worden, dus hebben we een mapje 'host_vars' aangemaakt in de map ansible. Hierien staat onze eerste host: namelijk pu004.yml
4.1 in de pu004.yml-file hebben we alle nodige instellingen gezet. (enable php scripting, naam van de database van mariadb, gebruiker aangemaakt voor mariadb, wachtwoordinstellingen voor mariadb-en wordpressgebruiker, services van firewall instellen: ssh, http, https)
5. Als dit allemaal correct is ingesteld, moet de pu004 correct kunnen geinitialiseerd worden met vagrant up.
6. Vagrant up pu004 en vervolgens vagrant ssh pu004.
7. Om de bovenstaande procedure te controleren op eventuele fouten, hebben we de testfile lamp.bats gerunt.


### Testplan en -rapport
Conclusie van de test:
Er zijn 5 of 6 fouten van de 16.
Een van deze fouten, wordt niet in rekening geacht (namelijk: Firewall: interface enp0s8 should be added to the public zone)
Om de overige fouten op te lossen:
1. In de lamp.bats moeten de mariadb_gebruiker en wachtwoorden overeenkomen met instellingen in de pu004.yml-file.
Als dit correct is verbeterd, dan zijn er al een aantal fouten weg.
2. Na het opnieuw runnen van de lamp.bats testfile, is er nog 1 test die moet opgelost worden. Dit omtrend de certificaten van de apache.
Om de certificaten te verkrijgen, hebben we eerst manueel de certificaten gegenereerd op de machine zelf. Deze hebben we vervolgens opgeslagen op het hostsysteem.
Hiervoor hebben we de rol httpd van bertvv aangepast:
files folder aangemaakt en hierin de certificaten gekopieert in de rol httpd.
In de default-map hebben we de main.yml aangepast, waarin we de directory van de httpd_SSLCertificateFile en httpd_SSLCertificateKeyFile hebben veranderd naar respectievelijk /etc/pki/tls/certs/ca.crt en /etc/pki/tls/private/ca.key.
als laatste moet in de task folder van de httpd-rol nog code worden toegevoegd, die de certificaten naar de juiste plaats kopieert.
Na deze aanpassingen, zijn er 15/16 test geslaagd. De laatste test moet niet opgelost worden.


### Retrospectieve

Ik heb eerst geprobeert om zelf een rol aan te maken. Hier ben ik bijna volledig in geslaagd, maar bij de laatste stap zou ik niet weten hoe je de directory's moet aanpassen in de conf-file...
Ik zou dit wel graag weten, en zou misschien ook willen weten hoe je met behulp van een ansible playbook de certifcaten zelf kan laten genereren. 
M.a.w. Kun je een roll aanmaken die een certificaat genereeert voor jou?

#### Wat ging goed?
De structuur van de ansible-omgeving gaat me al vrij goed af. Wat hoort waar begrijp ik nu al wat beter.

#### Wat ging niet goed?
Zelf de methode vinden om de certificaten te installeren. Na de tip van de meneer van vreckem ging alles vrij vlot.
Het opstellen van een eigen rol zorgt nog voor problemen.

#### Wat heb je geleerd?
We hebben geleerd hoe we 'snel' een lamp stack opstellen met mariadb, apache, en httpd services.

#### Waar heb je nog problemen mee?
Kun je een roll aanmaken die een certificaat genereeert voor jou?

### Referenties
http://docs.ansible.com/ansible/playbooks_roles.html
https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7
https://wiki.centos.org/HowTos/Https
http://www.azavea.com/blogs/labs/2014/10/creating-ansible-roles-from-scratch-part-1/
https://github.com/bertvv