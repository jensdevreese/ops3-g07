Import-GPO -BackupId 4FAD1344-F018-4E8C-A12E-E3C9A06F9555 -TargetName "GPOGebruikers" -Path ".\ConnexusGPO\JuisteGPO" -CreateIfNeeded
Get-GPO -Name "GPOGebruikers" | New-GPLink -Target "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

Import-GPO -BackupId C3E4A3E3-4B88-4AFB-89FB-4537654BDE7C -TargetName "GPOBeheerders" -Path ".\ConnexusGPO\JuisteGPO" -CreateIfNeeded
Get-GPO -Name "GPOBeheerders" | New-GPLink -Target "OU=AsAfdelingen,DC=ASSENGRAAF,DC=NL"

Import-GPO -BackupId A00694BC-B2B0-4120-B822-CDC6A9961453 -TargetName "Default Domain Policy" -Path ".\ConnexusGPO\JuisteGPO" -CreateIfNeeded
Get-GPO -Name "Default Domain Policy" | New-GPLink -Enforced Yes -Target "DC=ASSENGRAAF,DC=NL"

Import-GPO -BackupId 7F683349-41D6-4842-9323-DFCB1B06AA19 -TargetName "Default Domain Controllers Policy" -Path ".\ConnexusGPO\JuisteGPO" -CreateIfNeeded

gpupdate /force
