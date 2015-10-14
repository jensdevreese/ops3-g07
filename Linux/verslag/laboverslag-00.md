## Laboverslag: Opzetten werkomgeving

- Naam cursist: Jens De Vreese
- Bitbucket repo: https://bitbucket.org/JensDeVreese93/enterprise-linx-labo

### Procedures
## ---- 4. Versiebeheer ---- 
#--Installeren van SSH-keys in GIT bash
1. Surf naar de website git-scm.com en download een versie van Git (inclusief gitbash) best passend bij uw computer.
2. Eenmaal geïnstalleerd, Open 'git bash' op uw computer.
3. geef het commando "ssh-keygen -t -rsa -C "uwemail@domeinnaam.com". Na het uitvoeren van dit commando, gaat er een directory gecreëert worden waar uw keys worden opgeslagen. onthou de directory waar het bestand id_rsa.pub is opgeslagen. Voorbeeld van een mogelijke directory: c/users/gebruiker/.ssh/id_rsa.pub.
4. Kopieer de inhoud van rsa.pub met het commando: Clip < c/users/gebruiker/.ssh/id_rsa.pub
5. ga vervolgens naar bitbucket.org en registreer/meld u aan. klik vervolgens rechts bovenaan op uw account en ga naar 'Manage account'. Open vervolgens SSH keys onder het tabblad SECURITY. Klik op Add key, geef een toepassende naam voor de SSH key onder Label en plak tenslotte de inhoud van rsa.pub en bevestig door op 'add key' te klikken. Uw public key is succesvol aangemaakt.
## ---- 5.1 Vagrant -----
1. Ga naar www.vagrantup.com en download en installeer de laatste versie van Vagrant.
2. Zorg ervoor dat je de laatste versie van virtualBox hebt staan. Indien niet, kan je deze altijd downloaden in installeren van de website https://www.virtualbox.org/
3. Ga naar de directory waar je vagrantfile staat (voorbeeld: cd c/users/gebruiker/documents/enterprise-linux-labo) en je kan nu een overzicht van de VMs opvragen met het 'vagrant status'.
4. Start een VM met 'vagrant up [VM]' (vb: Vagrant up pu004). De eerste keer dat je dit doet wordt er een basis-vm gedownload met minimale installatie van CentOS 7.1.
5. Na het osptarten kan je inloggen met 'Vagrant ssh [VM]' (vb: Vangrant ssh pu004) met root-rechten.
## ---- 5.2 Ansible -----
# - Windows hostsysteem -
1. Ga naar de lokatie waar site.yml staat, en open dit bestand met een editor naar keuze (vb: vim users/gebruiker/documents/enterprise-linux-labo/ansible/site.yml).
2. Bij roles verwijder je de [] en voeg je vervolgens een rol te, geschreven in de vorm AUTEUR.ROLNAAM . (vb: in de host pu004 voeg je de role toe -  bertvv.el7)
3. Eenmaal de rol is toegekent, Kan deze geïnstalleerd worden. Dit kan via een vooropgesteld scriptje, geschreven door de heer van vreckem bert. (commando: bash scripts/role-deps.sh).
4. Vervolgens passen we de 'all.yml' in de group_vars aan. In deze file worden de variabelen gedefinieerd die voor alle hosts gelden. (vb: user aanmaken, admin toekennen, packages en repositories installeren,...)
5. Als de syntax correct is in de all.yml file, kan je nu met vagrant provision controleren of de wijzigingen doorgevoert zijn.

### Testplan en -rapport
Ga op het hostsysteem naar de directory met de lokale kopie van de repository.

1. Voer vagrant status uit
-> je zou één VM moeten zien met naam pu004 en status not created. Als deze toch bestaat, doe dan eerst
vagrant destroy -f pu004
2. Voer vagrant up pu004 uit
-> Het commando moet slagen zonder fouten (exitstatus 0)
3. Log in op de server met vagrant ssh pu004 en voer de acceptatietests uit:
4. voer het commando sudo /vagrant/test/runbats.sh uit op pu004.
-> Alles moet geinstalleerd zijn zonder failures: 10 tests, 0 failures.
5. Log uit en log vanop het hostsysteem opnieuw in, maar nu met ssh jens@192.0.2.50. Er mag geen wachtwoord gevraagd worden.

### Retrospectieve
## ---- 4. Versiebeheer ----
Alles is hier correct verlopen, tutorials op internet waren makkelijk te vinden.
## ---- 5.1 Vagrant -----
Vagrant commands lukten niet na installatie. Na herinstallatie van vagrantup en heropstarten van lokale machine, werkten deze commands wil.
## ---- 5.2 Ansible -----
De syntax van wat er in de all.yml moest komen was me in het begin niet volledig duidelijk. Het voorbeeld op de github van bert van vreckem was een hele grote hulp. Enkele vaakvoorkomende fouten hier waren: te veel/weinig spaties, kleine schrijffouten, de groep wheel toevoegen aan user was ik vergeten.
Na het testen bleek, dat ik de verkeerde runbats.sh had staan. Deze heb ik opnieuw moeten binnenhalen. Ook moest er in de common.bats nog enkele dingen aangepast worden ( het ^ voor epel moest weg, bert moest twee maal vervangen worden door mijn eigen username (jens)).


#### Wat ging goed?

- over het algemeen ging alles vrij goed. De ssh-keys installeren bracht geen problemen, vagrant installatie was ook snel up and running.  

#### Wat ging niet goed?

Ik heb vrij veel tijd gespendeerd aan het zoeken van de fout bij het uitvoeren van 'runbats.sh'. Eenmaal de runbats opnieuw binnengehaald was, verliep de rest vrij vlot. Mijn medestudenten hebben me geholpen met het correct opstellen van de variabelen in all.yml. Ook de common.bats moest aangepast worden.
 

#### Wat heb je geleerd?

Meer en meer raak ik vertrouwd met de linux-omgeving. Over het algemeen heb ik geleerd dat je via vagrantup makkelijk en snel virtuele machines kan deployen. Met behulp van ssh kan je deze machines bereiken.
Ik ben een eerste maal in contact gekomen met ansible. Ik ben hier te weten gekomen hoe je op voorhand rollen en users kunt toevoegen voor in het systeem.

#### Waar heb je nog problemen mee?

Ik moet nog wat meer vetrouwt geraken met de standaard linuxcommands, en met de verschillende directories.

### Referenties
https://www.youtube.com/watch?v=-ElU6WhNLn4
https://www.vagrantup.com
https://www.bitbucket.org/bertvv
https://www.git-scm.com
https://www.virtualbox.org/

