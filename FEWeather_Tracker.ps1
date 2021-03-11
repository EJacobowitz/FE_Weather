#Stage1

$station = @()
$station = Get-Content C:\temp\fe\FEtracker.json | ConvertFrom-Json

[int] $index = $station.station.name.IndexOf('DST')
[datetime] $convertDate = $station.station.Date[$index]

(get-date $convertDate).ToString("MM/dd/yyyy")

$username = $env:USERNAME
$Current_syssetpath = "\\cuaisilon\socappstgfile01\SOC_Share\stg1\FlightExplorer\profiles\FESTG1\$($username)\sysset.sys"
$Current_syssetfile = Get-ChildItem $Current_syssetpath

if ($Current_syssetfile.LastWriteTime -lt (get-date $convertDate).ToString("MM/dd/yyyy") ) { Write-Output "Need to copy new file...." }
