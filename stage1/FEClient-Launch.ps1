#Written By Erik Meyer
#Last Updated 09/12/2018

param($password, $ini, $department)

write-host "Welcome To Flight Explorer!"
Write-Host "***Please Wait While The Application Is Configured For Use***"
write-host ""
write-host "Environment: Staging 1"
write-host ""
write-host "Script Written By Erik Meyer"
write-host "Updated 09/12/2018"
write-host ""
C:\Applications\Stage1\FlightExplorer\FEClient-Launch\FEStatic_Upgrade.ps1 "C:\Progra~2\Flight~1\Professional\Stage1\festatic.dll"

#Folder Check
Function Foldercheck () {	
    $UserProfile = "\\cuaisilon\socappstgfile01\SOC_Share\Stg1\FlightExplorer\profiles\FESTG1\$uname"
    #$OldUserProfile = "H:\FESTG1"
    $ProductionProfile = "\\SOCAPPPRDFILE01\SOC_Share\FlightExplorer\Profiles\FEPRD"
    $Views = "\\cuaisilon\socappstgfile01\SOC_Share\Stg1\FlightExplorer\Files"

    if ((Test-Path -path $UserProfile -PathType container) -ne $True) {
        Write-Host "***Please Wait***"
        Write-Host "Creating Flight Explorer User Directory"			
        New-Item $UserProfile -type directory
        Start-Sleep -s 5
        Write-Host "Completed"
        Write-Host ""
		
        if ((Test-Path -path "$ProductionProfile\$uname\" -PathType container) -ne $False) {
            Write-Host "***Please Wait***"
            Write-Host "Copying files from Production $Uname Directory to Flight Explorer User Directory"
            Copy-Item -force "$ProductionProfile\$uname\*" $UserProfile
            Start-Sleep -s 5
            Write-Host "Completed"
            Write-Host ""
        }
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
    "MOD" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-MOD.exe' }
    "ATS" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-ATS.exe' }
    "DSP" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-DSP.exe' }
    "DOD" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-DOD.exe' }
    "CDM" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-CDM.exe' }
    "DST" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-DST.exe' }
    "COR" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-COR.exe' }
    "MOT" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-MOT.exe' }
    "CTL" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-CTL.exe' }
    "CSC" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-CSC.exe' }
    "ITA" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-ITA.exe' }
    "JBU" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-JBU.exe' }
    "OFF" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-OFF.exe' }
    "OVF" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-OVF.exe' }
    "PBK" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-PBK.exe' }
    "CSS" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-CSS.exe' }
	
    #Airport Stations executbales
    "JFK" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-JFK.exe' }
    "BOS" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-BOS.exe' }
    "FLL" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-FLL.exe' }
    "MCO" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-MCO.exe' }
    "SJU" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-SJU.exe' }
    "DCA" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-DCA.exe' }
    "EWR" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-EWR.exe' }
    "LGA" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-LGA.exe' }
    "LAX" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-LAX.exe' }
    "LAS" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-LAS.exe' }
    "BDL" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-BDL.exe' }
    "BWI" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-BWI.exe' }
    "PHL" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-PHL.exe' }
    "IAD" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-IAD.exe' }
    "ORD" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-ORD.exe' }
    "SLC" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-SLC.exe' }
    "SEA" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-SEA.exe' }
    "SAN" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-SAN.exe' }
    "CLT" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-CLT.exe' }
    "DTW" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-DTW.exe' }
    "DEN" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-DEN.exe' }
    "PVD" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-PVD.exe' }
    "DFW" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-DFW.exe' }
    "PHX" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-PHX.exe' }
    "HOU" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-HOU.exe' }
    "SFO" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-SFO.exe' }
    "LGB" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-LGB.exe' }
    "PBI" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-PBI.exe' }
    "MSP" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-MSP.exe' }
	
    #Support Center executables
    "RMG" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-RMG.exe' }
    "CPO" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-CPO.exe' }
    "SFY" { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient-SFY.exe' }
	
    default { $p1 = 'C:\Progra~2\Flight~1\Professional\Stage1\FEClient.exe' }
}
$p2 = $password
$p3 = $ini
$uname = [Environment]::UserName

cd "C:\Progra~2\Flight~1\Professional\Stage1\"
	
Switch ($department) {
    "ATS" {
        Foldercheck
        if ((Test-Path -path $UserProfile -PathType container) -ne $True) {
            $p3 = "C:\Progra~2\Flight~1\Professional\Stage1\FE"
        }
        Invoke-Expression "$p1 $p3"
    }
	
    "DSP" {
        Foldercheck
        if ((Test-Path -path $UserProfile -PathType container) -ne $True) {
            $p3 = "C:\Progra~2\Flight~1\Professional\Stage1\FE"
        }
        Invoke-Expression "$p1 $p3"
    }
	
    "DST" {
        Foldercheck
        if ((Test-Path -path $UserProfile -PathType container) -ne $True) {
            $p3 = "C:\Progra~2\Flight~1\Professional\Stage1\FE"
        }
        Invoke-Expression "$p1 $p3"
    }
	
    "PBK" {
        Foldercheck
        if ((Test-Path -path $UserProfile -PathType container) -ne $True) {
            $p3 = "C:\Progra~2\Flight~1\Professional\Stage1\FE"
        }
        Invoke-Expression "$p1 $p3"
    }
	
    default {
        Foldercheck
        if ((Test-Path -path $UserProfile -PathType container) -ne $True) {
            $p3 = "C:\Progra~2\Flight~1\Professional\Stage1\FE"
        }
        Invoke-Expression "$p1 $p2 $p3"
    }
}