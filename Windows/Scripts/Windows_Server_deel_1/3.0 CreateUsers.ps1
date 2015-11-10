$secpass = Read-Host “Password” –AsSecureString
Import-Csv werknemersAs.csv |
foreach {
	$name = “$($_.LastName) $($_.FirstName)”
	New-ADUser –GivenName $($_.FirstName) –Surname $($_.LastName) –Name $name`
	-SamAccountName $($_.SamAccountName) –UserPrincipalName “$($_.SamAccountName)@Assengraaf.nl” –AccountPassword $secpass –Path “cn=Users, dc= Assengraaf, dc = nl” –Enabled:$true
}