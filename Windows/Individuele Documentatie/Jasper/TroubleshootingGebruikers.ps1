#Troubleshooting, 3 stappen: 1. Kijken als het account geactiveerd is, 2.Kijken of het account verlopen is, 3. Kijken of een gebruiker buitengesloten is uit zijn account
#Zoeken naar accounts die disabled zijn
Search-ADAccount –AccountDisabled | select Name, samAccountName

#Kijken of het account verlopen is
Search-ADAccount –AccountExpired | Format-Table Name, SamAccountName, DistinguishedName, accountExpirationDate –AutoSize

#Kijken of het wachtwoord verlopen is
Search-ADAccount –PasswordExpired

#Kijken of een gebruiker buitengesloten is
Search-ADAccount -LockedOut 