#Opmerking: Bij virtual box moeten er eerst 2 nieuwe virtuele harde schijven worden aangemaakt, vooraleer dit script werkt.

########################
# Initialize the disks #
########################
Initialize-Disk 1 -PartitionStyle MBR
Initialize-Disk 2 -PartitionStyle MBR

#####################
# Create partitions #
#####################
New-Partition -DiskNumber 1 -UseMaximumSize -DriveLetter E
New-Partition -DiskNumber 2 -UseMaximumSize -DriveLetter F

#########################
# Format the partitions #
#########################
Format-Volume -DriveLetter E -Force
Format-Volume -DriveLetter F -Force
