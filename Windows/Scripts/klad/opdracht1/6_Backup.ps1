######################
# Add Backup feature #
######################
Add-WindowsFeature Windows-Server-Backup -IncludeManagementTools

#########################
# Define backup options #
#########################
$policy = New-WBPolicy
$BackupTargetVolume = New-WBBackupTarget -VolumePath F:
$filespec = New-WBFileSpec -FileSpec E:

Add-WBFileSpec -Policy $policy -FileSpec $filespec
Add-WBBackupTarget -Policy $policy -Target $BackupTargetVolume

##############
# Run backup #
##############
Start-WBBackup -Policy $policy