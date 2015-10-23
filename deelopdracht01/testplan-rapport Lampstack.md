## Testplan en -rapport taak 1: Opzetten LAMPstack

* Verantwoordelijke uitvoering: Jens De Vreese
* Verantwoordelijke testen: Mathias Van Rumst

### Testplan

Auteur(s) testplan: Jens De Vreese & Sébastien Pattyn
Voor de het opzetten van een lampstack, maken we gebruik 'Vagrant' en van de lampstack die op de githubrepository staat van de heer Bert Van Vreckem.
De stappen die we overlopen zijn allemaal op windows-hostsystemen.
Dit is het stappenplan die we gevolgd hebben:
#stap 1: we maken een clone van de lampstack
git clone --config core.autocrlf=input https://github.com/bertvv/lampstack
#stap 2: ga naar de directory waar deze lampstack in gecloned is (in ons geval '../lampstack')
cd lampstack
#stap 3: Run het scrip van de dependencies om alles correct te installeren.
./scripts/dependencies.sh
#stap 4: Vervolgs gaan we de vagrantfile up'en voor het locaal opzetten van de lampstack.
vagrant up lampstack
#stap 5: Als alles correct is verlopen, en alle configuratiefiles zijn zonder fouten geinstalleerd.  
moet het mogelijk zijn om te ssh'n vanuit een locale terminal naar de vagrant.
vagrant ssh lampstack
=> Als je kan ssh'n naar je lampstack, is je lampstack up and running.


### Testrapport

Uitvoerder(s) test: Mathias Van Rumst

- ...
