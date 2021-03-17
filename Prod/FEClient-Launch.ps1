#Written By Erik Meyer
#06/05/2017

#Updated 06/25/2018
#Updated by Eric Jacobowitz
#Revision - function to check Airport (C70) file and update it if needed


#Updated 05/16/2019
#Updated by Erik Meyer
#Revision - Added PIT - Pittsburgh
#Revision - Removed H: drive

#Updated 05/16/2019
#Updated by Erik Meyer
#Revision - updates NAS paths to new NAS

#Update 03/16/2021
#Updated by Eric Jacobowitz
#Revision - Modified the folder check function to copy sysset.sys with new weather configs

param($password, $ini, $department)

write-host "Welcome To Flight Explorer!"
Write-Host "***Please Wait While The Application Is Configured For Use***"
write-host ""
write-host "Environment: Production"
write-host ""
write-host "Script Written By Erik Meyer"
write-host "Updated 05/16/2019"
write-host ""
C:\Applications\FlightExplorer\FEClient-Launch\FEStatic_Upgrade.ps1

#Airports ( C70 ) file
function get-airports () {
    #Will check a default location and update based on that file timestamp
    
    If (Test-path -Path \\soc\soc\ITOperationsSupport\FEPRO\Airports.txt) {
        $Source = get-item "\\soc\soc\ITOperationsSupport\FEPRO\Airports.txt"
        $Destination = get-item 'C:\Program Files (x86)\Flight Explorer\Professional\Groups\Airports.txt'
        If ($Source.LastWriteTime -gt $Destination.LastWriteTime) {
            Copy-Item -Path $Source -Destination $Destination -Force
        }
    }
}

#Folder Check
Function Foldercheck () {	
    $UserProfile = "\\soc\soc\applications\FlightExplorer\Profiles\FEPRD\$uname"
    $Views = "\\soc\soc\applications\FlightExplorer\Files"

    if ((Test-Path -path $UserProfile -PathType container) -ne $True) {
        Write-Host "***Please Wait***"
        Write-Host "Creating Flight Explorer User Directory"			
        New-Item $UserProfile -type directory
        Start-Sleep -s 5
        Write-Host "Completed"
        Write-Host ""		
    }

    #If missing sysset.sys copy new sysset with http weather
    Write-Host "***Please Wait***"
    Write-Host "***Checking SysSet.sys file***"
    $station = (Get-Content "$($Views)\FEtracker.json" | ConvertFrom-Json).station
    if ($false -eq (Test-Path -Path "$($UserProfile)\sysset.sys")) {
        switch ($department) {
            'ATS' { Copy-Item -Path "$($Views)\SysSet.ATS" -Destination $UserProfile }
            'DSP' { Copy-Item -Path "$($Views)\SysSet.DSP" -Destination $UserProfile }
            'DST' { Copy-Item -Path "$($Views)\SysSet.DST" -Destination $UserProfile }
            'PBK' { Copy-Item -Path "$($Views)\SysSet.PBK" -Destination $UserProfile }
            Default { Copy-Item -Path "$($Views)\SysSet.default" -Destination $UserProfile }
        }
        Else {
            [int] $index = $station.name.IndexOf($department)
            [datetime] $convertDate = $station.Date[$index]
            $newfile = ($station.File[$index]).Replace("/", "\")
            $Current_syssetpath = "$($UserProfile)\sysset.sys"
            $Current_syssetfile = Get-ChildItem $Current_syssetpath
            
            if ((get-date $Current_syssetfile.LastWriteTime) -lt (get-date $convertDate) ) { copy-item -Path $newfile -Destination $Current_syssetfile.FullName }else { Write-Output "Do not need to copy" }
        }
    }
    Write-Host "Completed"
    Write-Host ""
    #End Sysset.sys
    
    Write-Host "***Please Wait***"
    Write-Host "Copying UDViewPUB.sys"
    Copy-Item -force "$Views\UDViewPub.sys" $UserProfile
    Start-Sleep -s 5
    Write-Host "Completed"
    Write-Host ""

    Write-Host "***Please Wait***"
    Write-Host "Deleting FEEvents.csv"
    Start-Sleep -s 5
    Remove-Item -force "$UserProfile\*.csv"
    Write-Host "Completed"
    Write-Host ""
}

Switch ($department) {
    #System Operations Center executbales
    "MOD" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-MOD.exe' }
    "ATS" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-ATS.exe' }
    "DSP" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-DSP.exe' }
    "DOD" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-DOD.exe' }
    "CDM" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-CDM.exe' }
    "DST" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-DST.exe' }
    "COR" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-COR.exe' }
    "MOT" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-MOT.exe' }
    "CTL" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-CTL.exe' }
    "CSC" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-CSC.exe' }
    "ITA" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-ITA.exe' }
    "JBU" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-JBU.exe' }
    "OFF" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-OFF.exe' }
    "OVF" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-OVF.exe' }
    "PBK" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-PBK.exe' }
    "CSS" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-CSS.exe' }
	
    #Airport Stations executbales
    "JFK" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-JFK.exe' }
    "BOS" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-BOS.exe' }
    "FLL" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-FLL.exe' }
    "MCO" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-MCO.exe' }
    "SJU" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-SJU.exe' }
    "DCA" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-DCA.exe' }
    "EWR" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-EWR.exe' }
    "LGA" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-LGA.exe' }
    "LAX" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-LAX.exe' }
    "LAS" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-LAS.exe' }
    "BDL" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-BDL.exe' }
    "BWI" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-BWI.exe' }
    "PHL" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-PHL.exe' }
    "IAD" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-IAD.exe' }
    "ORD" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-ORD.exe' }
    "SLC" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-SLC.exe' }
    "SEA" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-SEA.exe' }
    "SAN" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-SAN.exe' }
    "CLT" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-CLT.exe' }
    "DTW" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-DTW.exe' }
    "DEN" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-DEN.exe' }
    "PVD" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-PVD.exe' }
    "DFW" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-DFW.exe' }
    "PHX" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-PHX.exe' }
    "HOU" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-HOU.exe' }
    "SFO" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-SFO.exe' }
    "LGB" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-LGB.exe' }
    "PBI" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-PBI.exe' }
    "MSP" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-MSP.exe' }
    "PIT" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-PIT.exe' }
	
    #Support Center Executables
    "RMG" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-RMG.exe' }
    "CPO" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-CPO.exe' }
    "SFY" { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient-SFY.exe' }
	
    default { $p1 = 'C:\Progra~2\Flight~1\Professional\FEClient.exe' }
}
$p2 = $password
$p3 = $ini
$uname = [Environment]::UserName
get-airports 

cd "C:\Progra~2\Flight~1\Professional\"
	
Switch ($department) {
    "ATS" {
        Foldercheck
        Invoke-Expression "$p1 $p3"
    }
	
    "DSP" {
        Foldercheck
        Invoke-Expression "$p1 $p3"
    }
	
    "DST" {
        Foldercheck
        Invoke-Expression "$p1 $p3"
    }
	
    "PBK" {
        Foldercheck
        Invoke-Expression "$p1 $p3"
    }
	
    default {
        Foldercheck
        Invoke-Expression "$p1 $p2 $p3"
    }
}