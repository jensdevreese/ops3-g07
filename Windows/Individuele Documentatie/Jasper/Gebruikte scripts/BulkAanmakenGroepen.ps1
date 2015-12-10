Import-Csv –Path ./groups.csv |
foreach{
	New-ADGroup –Name $PSItem.Name –Path “CN= Users, DC=Assengraaf,DC=nl”
-GroupCategory Security –GroupScope global –Description $PSItem.Description
}
