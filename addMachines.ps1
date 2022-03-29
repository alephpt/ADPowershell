## Paste this script with your credentials into the browser before running ##

# $joinCred = New-Object pscredential -ArgumentList ([pscustomobject]@{
# UserName = 'your username'
# Password = (ConvertTo-SecureString -String 'your password' -AsPlainText -Force)[0]
# })

## set your destination Organization Unit directory/path
$ouPath = 'OU=, OU=, OU=, DC=, DC='

## opens local CSV, queries whether a device exists, adds it to AD if Not
Import-Csv -Path '.\remaining.csv' | ForEach-Object{
  $pcName = $_.Computers
  if (Get-ADComputer -Filter { Name -eq $pcName }) {
    Write-Host "$pcName already Exists in Active Directory."
  } else {
    New-ADComputer -Name $pcName -Path $ouPath -Credential $joinCred
    if (Get-ADComputer -Filter { Name -eq $pcName }) { 
        Write-Host "$pcName has been added to Active Directory." 
    } else { 
        Write-Host "Adding $pcName to Active Directory Failed." 
    }
  }
}