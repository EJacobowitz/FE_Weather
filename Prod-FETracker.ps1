#Prod
$station = @()
$station = Get-Content \\soc\soc\Applications\FlightExplorer\Files\FEtracker.json | ConvertFrom-Json

[int] $index = $station.station.name.IndexOf('DST')
[datetime] $convertDate = $station.station.Date[$index]
$newfile = ($station.station.File[$index]).Replace("/", "\")

$username = $env:USERNAME
$Current_syssetpath = "\\soc\soc\Applications\FlightExplorer\Profiles\FEPRD\$($username)\sysset.sys"
$Current_syssetfile = Get-ChildItem $Current_syssetpath

if ($Current_syssetfile.LastWriteTime.ToString("MM/dd/yyyy") -lt (get-date $convertDate).ToString("MM/dd/yyyy") ) { copy-item -Path $newfile -Destination $Current_syssetfile.FullName }else { Write-Output "Do not need to copy" }
