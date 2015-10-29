$gpolinks = Get-ADOrganizationalUnit –Filter * |
where LinkedGroupPolicyObjects |
foreach {
    $ou = $PSItem.DistinguishedName
    $PSItem.LinkedGroupPolicyObjects |
    foreach {
	    $x = $PSItem.ToUpper() -split ",", 2
        $id = $x[0].Replace("CN={","").Replace("}","")
        $props = [ordered]@{
            OU=$ou
            GPO=Get-GPO -Guid $id | select -ExpandProperty DisplayName
        }
        New-Object -TypeName PSObject -Property $props
    }
}
#sorteren op wat je wil, OU of GPO
$gpolinks | sort OU | Format-Table OU, GPO -AutoSize
$gpolinks | sort GPO | Format-Table GPO, OU -AutoSize

