## Scans list of devices found in devices.txt and determines status, 
## outputting online.txt

$complist = Get-Content "devices.txt"

$compobjs = New-Object System.Collections.Generic.List[System.Object]
$Count = 1

foreach($comp in $complist){
    Write-Progress -Id 0 -Activity "Scanning Device List" -Status "$Count of $($complist.Count)" -PercentComplete (($Count / $complist.Count) * 100)
    $pingtest = Test-Connection -ComputerName $comp -Quiet -Count 1 -ErrorAction SilentlyContinue
    if($pingtest){
         $compobjs.Add([string]$comp)
     }
     $Count++    
}

Write-Verbose "Building the report..." -Verbose
$compobjs | Out-File -FilePath .\online.txt