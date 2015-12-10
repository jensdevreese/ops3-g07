$secpass = Read-Host “Password” –AsSecureString
New-ADUser –Name “GREEN Dave” –SamAccountName dgreen –UserPrincipalName “dgreen@Assengraaf.nl” –AccountPassword $secpass –Path “cn=Users, dc= Assengraaf, dc = nl” –Enabled:$true
