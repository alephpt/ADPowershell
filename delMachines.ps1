## Paste this script with your credentials into the browser before running ##

#$joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
#UserName = '#'
#Password = (ConvertTo-SecureString -String '#' -AsPlainText -Force)[0]
#})

## queries Active Directory database for Computer Names
## offering prompt with Name and OU for deletion
Import-Csv -Path '.\remaining.csv' | ForEach-Object{
$pcName = $_.Computers
Get-ADComputer -Filter { Name -eq $pcName } | Remove-ADComputer -Credential $joinCred
}

write-host "Active Directory Removal Completed."