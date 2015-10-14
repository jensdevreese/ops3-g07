## Testplan en -rapport taak 1: LAMP-stack opzetten
* Verantwoordelijke uitvoering: Jens De Vreese
* Verantwoordelijke testen: Jens De Vreese

### Testplan
Auteur(s) testplan: Jens De Vreese

Voor het projectgedeelte van Linux moeten we een LAMP-stack opzetten die vervolgens op verschillende manieren gemonitord zal worden. De eerste stap in de procedure is dus het opzetten van de LAMP-stack via vagrant.
De werkomgeving en de lampstack moet aan de volgende eisen voldoen:

*Er moet kunnen een ssh-verbinding gelegd worden met de virtuele machine, zonder dat er een wachtwoord word gevraagd. Voor het gemak wordt er een Message Of The Day getoont.
*Volgende packages moeten geinstalleerd zijn :
	- EPEL repository
	- Bash-completion
	- bind-utils
	- Git
	- Nano
	- Tree
	- Vim-enhanced
	- Wget
*Alle code zit in de Github repository
*Na het uitvoeren van vagrant up moet er een werkende VM met Apache+PHP en MariaDB up en running zijn.
*Er moet een basisbeveiliging van MariaDB zijn.
*De firewall- en SELinux-instellingen zijn correct ingesteld.
*Na vagrant up is er de aanwezigheid van MySQL mét een DB voor de app.
*Na vagrant up moet de Wordpress installatiepagina zichtbaar zijn.
*Er is HTTPS-ondersteuning met self-signed certificaten.

Voor het volgen van het testplan, zijn er twee testscripts geschreven door Bert Van Vreckem die de recruirements controleert (LAMP.bats en Common.bats).
Deze bats-files moet je in je testfolder zetten en deze vervolgens runnen via runbats.sh in de machine. Deze runbats.sh gaat iedere bats-file overlopen en uitvoeren.


### Testrapport
Uitvoerder(s) test: Jens De Vreese
Controle pu004 not created yet 'Vagrant status pu004':
![screenschot vagrantStatus] (https://bytebucket.org/JensDeVreese93/enterprise-linux-labo/raw/3ef2f25847913fd47fc937f3e2455372d2ed3e4b/Afbeeldingen/VagrantStatus.PNG?token=866bdfaf662dbaa16c2dbea5402d10646bd3c5ce)

Vagrant up pu004.
![screenschot VagrantUp1] (https://bytebucket.org/JensDeVreese93/enterprise-linux-labo/raw/3ef2f25847913fd47fc937f3e2455372d2ed3e4b/Afbeeldingen/VagrantUp1.PNG?token=3dd2fd4054fd2890c9091c6b0120ba3d33c0e96c)

Vagrant status pu004
![screenschot VagrantStatus2] (https://bytebucket.org/JensDeVreese93/enterprise-linux-labo/raw/3ef2f25847913fd47fc937f3e2455372d2ed3e4b/Afbeeldingen/VagrantStatus2.PNG?token=52ca0955a5acdb00edf6ab6ef9f2eb93ae3de4e6)

Vagrant ssh pu004.
![screenschot VagrantSSH] (https://bytebucket.org/JensDeVreese93/enterprise-linux-labo/raw/3ef2f25847913fd47fc937f3e2455372d2ed3e4b/Afbeeldingen/VagrantSSH.PNG?token=4df2a0b9114a963cbca140b71b43e60f7ad081ff)

Uitvoer na het runnen van de test:
sudo vagrant/test/runbats.sh
![screenschot common-bats] (https://bytebucket.org/JensDeVreese93/enterprise-linux-labo/raw/3ef2f25847913fd47fc937f3e2455372d2ed3e4b/Afbeeldingen/TestCommon.PNG?token=ef88d5d21de9b6c36058ac6babe75dc41fb87f97)
![screenschot LAMP-bats] (https://bytebucket.org/JensDeVreese93/enterprise-linux-labo/raw/3ef2f25847913fd47fc937f3e2455372d2ed3e4b/Afbeeldingen/TestLamp.PNG?token=ea9d5414ba22ab4101233397fcbdbfcabf82d303)



### Testscript inhoud: LAMP.bats

#! /usr/bin/env bats
#
# Author: Bert Van Vreckem <bert.vanvreckem@gmail.com>
#
# Acceptance test script for a LAMP stack with Wordpress

#{{{ Helper Functions


#}}}
#{{{ Variables
sut=192.0.2.50
mariadb_root_password=root
wordpress_database=wordpress
wordpress_user=wp_user
wordpress_password=root
#}}}

# Test cases

@test 'The necessary packages should be installed' {
  rpm -q httpd
  rpm -q mariadb-server
  rpm -q wordpress
  rpm -q php
  rpm -q php-mysql
}

@test 'The Apache service should be running' {
  systemctl status httpd.service
}

@test 'The Apache service should be started at boot' {
  systemctl is-enabled httpd.service
}

@test 'The MariaDB service should be running' {
  systemctl status mariadb.service
}

@test 'The MariaDB service should be started at boot' {
  systemctl is-enabled mariadb.service
}

@test 'The SELinux status should be ‘enforcing’' {
  [ -n "$(sestatus) | grep 'enforcing'" ]
}


@test 'Web traffic should pass through the firewall' {
  firewall-cmd --list-all | grep 'services.*http\b'
  firewall-cmd --list-all | grep 'services.*https\b'
}

@test 'Mariadb should have a database for Wordpress' {
  mysql -uroot -p${mariadb_root_password} --execute 'show tables' ${wordpress_database}
}

@test 'The MariaDB user should have "write access" to the database' {
  mysql -u${wordpress_user} -p${wordpress_password} \
    --execute 'CREATE TABLE a (id int); DROP TABLE a;' \
    ${wordpress_database}
}

@test 'The website should be accessible through HTTP' {
  # First check whether port 80 is open
  [ -n "$(ss -tln | grep '\b80\b')" ]

  # Fetch the main page (/) with Curl/
  #  - If the site is not up, curl will exit with an error and the test will fail
  #  - If the site is up, but the index page cannot be found, ${result} will be nonempty
  run curl --silent "http://${sut}/"
  [ -z "$(echo ${output} | grep 404)" ]
}

@test 'The website should be accessible through HTTPS' {
  # We're just checking if port 443 is open here. If HTTP runs and serves pages, HTTPS should as well
  # We check the open TCP server ports with ss and check if port 443 is listed.
  [ -n "$(ss -tln | grep '\b443\b')" ]
}

@test 'The certificate should not be the default one' {
  # Fetch the server certificate
  run openssl s_client -showcerts -connect ${sut}:443 < /dev/null

  [ "0" -eq "${status}" ]

  # The default certificate for Apache has "SomeOrganization" as the organization
  # So grepping it in the output of the openssl command should return an empty string
  # if a self-signed certificate was installed by the administrator.
  [ -z "$(echo ${output} | grep SomeOrganization)" ]
}

@test "The Wordpress install page should be visible under http://${sut}/wordpress/" {
  [ -n "$(curl --silent --location http://${sut}/wordpress/ | grep '<title>WordPress')" ]
}

@test 'MariaDB should not have a test database' {
  run mysql -uroot -p${mariadb_root_password} --execute 'show tables' test
  [ "0" -ne "${status}" ]
}

@test 'MariaDB should not have anonymous users' {
  result=$(mysql -uroot -p${mariadb_root_password} --execute "select * from user where user='';" mysql)
  [ -z "${result}" ]
}

