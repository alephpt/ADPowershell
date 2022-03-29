
## AD Script to Query AD Objects and Output a CSV with Name, Logon Date, OS and BL Info

Import-Module ActiveDirectory

$ouPath = 'OU=, OU=, OU=, DC=, DC='

Write-Verbose "Getting Workstations..." -Verbose
$Computers = Get-ADComputer -Filter * -SearchBase $ouPath -Properties LastLogonDate,OperatingSystem
$Count = 1
$Results = ForEach ($Computer in $Computers)
{
    Write-Progress -Id 0 -Activity "Searching Computers for BitLocker" -Status "$Count of $($Computers.Count)" -PercentComplete (($Count / $Computers.Count) * 100)
    New-Object PSObject -Property @{
        ComputerName = $Computer.Name
        LastLogonDate = $Computer.LastLogonDate 
        OperatingSystem = $Computer.OperatingSystem
        BitLockerPasswordSet = Get-ADObject -Filter "objectClass -eq 'msFVE-RecoveryInformation'" -SearchBase $Computer.distinguishedName -Properties msFVE-RecoveryPassword,whenCreated,OperatingSystem | Sort LastLogonDate -Descending | Select -First 1 | Select -ExpandProperty whenCreated
    }
    $Count ++
}
Write-Progress -Id 0 -Activity " " -Status " " -Completed

$ReportPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) -ChildPath "WorkstationsWithBitLocker.csv"
Write-Verbose "Building the report..." -Verbose
$Results | Select ComputerName,LastLogonDate,OperatingSystem,BitLockerPasswordSet | Sort ComputerName | Export-Csv $ReportPath -NoTypeInformation
Write-Verbose "Report saved at: $ReportPath" -Verbose
