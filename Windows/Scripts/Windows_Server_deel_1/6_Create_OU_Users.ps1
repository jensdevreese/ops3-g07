###############################
# Create Userfolder directory #
###############################
$Path = "E:\UserFolders"
$Name = "UserFolders$"
$Admins = "ASSENGRAAF\Domain Admins"
$Users = "ASSENGRAAF\Domain Users"

New-Item -Path $Path -ItemType directory
New-SmbShare -Name $Name -Path $Path -FullAccess $Admins
Grant-SmbShareAccess -Name $Name -AccountName $Users -AccessRight Read -Force
Grant-SmbShareAccess -Name $Name -AccountName $Users -AccessRight Change -Force

#############
# Create OU #
#############
$groups = @("Directie","Financieringen","Staf","Verzekeringen","Beheer")
$Path = "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

New-ADOrganizationalUnit -Name AsAfdelingen -ProtectedFromAccidentalDeletion $false

foreach ($group_name in $groups)
{
    New-ADOrganizationalUnit -Name $group_name `
    -Path $Path `
    -ProtectedFromAccidentalDeletion $false
}


#################
# Create groups #
#################
$groups = @("Directie","Financieringen","Staf","Verzekeringen","Beheer")

foreach ($group_name in $groups)
{
    New-ADGroup -Name "S_$group_name" -Description "Global security group voor $group_name" `
    -GroupScope Global -SamAccountName "S_$group_name" `
    -GroupCategory Security `
    -Path "OU=$group_name,OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"
}

$global_groups = @("Gebruikers","Beheerders")

foreach ($group_name in $global_groups)
{
    New-ADGroup -Name "S_$group_name" -Description "Global security group voor $group_name" `
    -GroupScope Global -SamAccountName "S_$group_name" `
    -GroupCategory Security `
    -Path "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"
}

$groups = @("Directie","Financieringen","Staf","Verzekeringen")
foreach ($group_name in $groups)
{
    $adgroup = Get-ADGroup -Identity "CN=S_$group_name,OU=$group_name,OU=AsAfdelingen,DC=Assengraaf,DC=nl"
    $group_to_add = Get-ADGroup -Identity "CN=S_Gebruikers,OU=AsAfdelingen,DC=Assengraaf,DC=nl"
    Add-ADGroupMember -Identity $group_to_add -Members $adgroup
}

$groups = @("Beheer")
foreach ($group_name in $groups)
{
    $adgroup = Get-ADGroup -Identity "CN=S_$group_name,OU=$group_name,OU=AsAfdelingen,DC=Assengraaf,DC=nl"
    $group_to_add = Get-ADGroup -Identity "CN=S_Beheerders,OU=AsAfdelingen,DC=Assengraaf,DC=nl"
    Add-ADGroupMember -Identity $group_to_add -Members $adgroup
}

###########################
# Create Departmentshares #
###########################
$shares = @("Directie","Financieringen","Staf","Verzekeringen","Beheer")
$Path = "E:\Afdelingsmappen"
$Admins = "ASSENGRAAF\Domain Admins"

New-Item -Path $Path -ItemType directory

foreach ($share_name in $shares)
{
    $full_path = $Path + "\" + $share_name
    $group_path = "S_"+$share_name
    New-Item -Path $full_path -ItemType directory

    New-SmbShare -Name $share_name -Path $full_path -FullAccess $Admins
    Grant-SmbShareAccess -Name $share_name -AccountName $group_path -AccessRight Read -Force
    Grant-SmbShareAccess -Name $share_name -AccountName $group_path -AccessRight Change -Force
    

    $full_group_path = "ASSENGRAAF\"+$group_path

    $ACL = Get-Acl $full_path
    #$ACL.SetAccessRuleProtection($true, $false)
    #$ACL.Access | ForEach { [Void]$ACL.RemoveAccessRule($_) }
    $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule("ASSENGRAAF\Administrator","FullControl", "ContainerInherit, ObjectInherit", "None", "Allow")))
    $ACL.AddAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($full_group_path,"Modify", "ContainerInherit, ObjectInherit", "None", "Allow")))
    Set-Acl $full_path $ACL

    #Remove-SmbShare -Name $share_name -Force
    #rmdir -Path $full_path -Force
    #rmdir -Peth $Path -Force
}

################
# Create Users #
################
$Path = ".\6_werknemers.csv"
$Delimiter = ","
$principal = "@ASSENGRAAF.NL"
$main_OU = "OU=AsAfdelingen,DC=Assengraaf,DC=nl"
$profile_path = "\\AsSv1\UserFolders$\%username%"
$password = "Test123"

#We weten dat het toevoegen van een wachtwoord in het script niet bepaald veilig is.
#Best practice is een wachtwoord zo te vragen: $secpass = Read-Host “Password” –AsSecureString
#En dan als parameter: –AccountPassword $secpass
#Dit doen we deze keer niet omwille van gemaksredenen bij het testen

foreach ($User in Import-Csv -Delimiter $Delimiter -Path $Path)
{
    $OU = "OU="+ $User.OU + "," +$main_OU
    $Name = $User.GivenName + " " + $User.Surname
    $SAM = $User.GivenName.Substring(0,3) + "_" + $User.Surname.Substring(0,3)
	$UserPrincipalName = $SAM + $principal
    $homedir = "\\ASSV1\" + $User.OU
	
	#Create the user
	New-ADUser -Name $Name `
		-GivenName $User.GivenName`
		-Surname $User.Surname `
		-EmployeeNumber $User.Number `
		-SamAccountName $SAM `
		-UserPrincipalName $UserPrincipalName `
		-AccountPassword (ConvertTo-SecureString -AsPlainText $password -Force) `
		-Path $OU `
        -ProfilePath $profile_path `
        -HomeDrive 'Z:' `
        -HomeDirectory $homedir `
		-PassThru | Enable-ADAccount

    $usr = "CN=$Name,OU="+ $User.OU + ",OU=AsAfdelingen,DC=Assengraaf,DC=nl"

    $OU = "CN=S_"+ $User.OU +",OU=" + $User.OU + "," +$main_OU
    $user = Get-ADUser -Identity $usr
    Add-ADGroupMember -Identity $OU -Members $user
}

########################
# Add Femke to group's #
########################
$OU = @("CN=Account Operators,CN=Builtin,DC=Assengraaf,DC=nl","CN=Backup Operators,CN=Builtin,DC=Assengraaf,DC=nl")
$user = Get-ADUser -Identity "CN=Femke Van De Vorst,OU=Directie,OU=AsAfdelingen,DC=Assengraaf,DC=nl"

foreach ($ou_to_add in $OU)
{
    Add-ADGroupMember -Identity $ou_to_add -Members $user   
}

#####################
# Block inheritance #
#####################
$OUPath = "OU=Beheer,OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

Set-GPInheritance -Target $OUPath -IsBlocked Yes

################
# Add printers #
################
$printers = @("PFPR1","PFPR2")

Add-PrinterDriver -Name "HP Color LaserJet 2500 PS Class Driver"

foreach ($printer in $printers)
{
    $port = $printer + "PORT"
    Add-PrinterPort -Name $port
    Add-Printer -DriverName "HP Color LaserJet 2500 PS Class Driver" -Name $printer -PortName $port -Published -Shared -ShareName $printer     
}
.\pause_printers.vbs
