#Prod
$station = @()
$station = (Get-Content \\soc\soc\Applications\FlightExplorer\Files\FEtracker.json | ConvertFrom-Json).station

[int] $index = $station.name.IndexOf('DST')
[datetime] $convertDate = $station.Date[$index]
$newfile = ($station.File[$index]).Replace("/", "\")

$username = $env:USERNAME
$Current_syssetpath = "\\soc\soc\Applications\FlightExplorer\Profiles\FEPRD\$($username)\sysset.sys"
$Current_syssetfile = Get-ChildItem $Current_syssetpath

if ((get-date $Current_syssetfile.LastWriteTime) -lt (get-date $convertDate) ) { copy-item -Path $newfile -Destination $Current_syssetfile.FullName }else { Write-Output "Do not need to copy" }
