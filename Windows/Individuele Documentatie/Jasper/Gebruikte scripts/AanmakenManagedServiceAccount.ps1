New-ADServiceAccount –Name TestAccount –Path “CN= Managed Service Accounts,DC=Assengraaf, DC=nl” –DNSHostName TestAccount.Assengraaf.nl –Enabled $true
Add-KdsRootKey –EffectiveImmediately
