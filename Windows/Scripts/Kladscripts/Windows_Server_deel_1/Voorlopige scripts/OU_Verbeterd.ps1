# New-ADOrganizationalUnit -Name AsAfdelingen -Path 'DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $True
# New-ADOrganizationalUnit -Name beheer -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $True
# New-ADOrganizationalUnit -Name directie -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $True
# New-ADOrganizationalUnit -Name verzekering -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $True
# New-ADOrganizationalUnit -Name finaciering -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $True
# New-ADOrganizationalUnit -Name staf -Path 'OU=AsAfdelingen,DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $True
# New-ADOrganizationalUnit -Name nieuweleden -Path 'DC=Assengraaf,DC=NL' -ProtectedFromAccidentalDeletion $True

# #Block inheritance
# Set-GPinheritance -Target "OU=beheer, DC=Assengraaf, DC=NL" -IsBlocked Yes

# #Commentaar bij ou's
# Get-ADOrganizationalUnit -Filter {Name -eq 'beheer'} | Set-ADOrganizationalUnit -Description "User accounts van de beheerders"


#############
# Create OU #
#############
#Alle OU's in een array steken zodat het later makkelijker is om nieuwe OU's toe te voegen
$groups = @("Directie","Financieringen","Staf","Verzekeringen","Beheer")
#Het path opgeven waar de OU's terecht komen
$Path = "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

#De hoofd OU aanmaken waar de andere in komen normaal moet -ProtectedFromAccidentalDeletion op "true" staan maar hier wordt het gedaan ter performantie
New-ADOrganizationalUnit -Name AsAfdelingen -ProtectedFromAccidentalDeletion $false
#Alle elementen in de groups array overlopen en ze aanmaken in het path en er de bijhorende beschrijving bijzetten
foreach ($group_name in $groups)
{
    New-ADOrganizationalUnit -Name $group_name `
    -Path $Path `
    -ProtectedFromAccidentalDeletion $false `
    -Description "OU van " + $group_name +"."
}
