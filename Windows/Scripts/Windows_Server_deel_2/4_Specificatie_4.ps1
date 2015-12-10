###############
# Join Domain #
###############

$domain = "Assengraaf.nl"
$password = "Test123" | ConvertTo-SecureString -asPlainText -Force
$username = "$domain\Administrator" 
$credential = New-Object System.Management.Automation.PSCredential($username,$password)
Add-Computer -DomainName $domain -Credential $credential