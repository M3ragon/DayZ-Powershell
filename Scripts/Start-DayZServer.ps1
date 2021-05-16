# DayZ Start Powershell by M3ragon
# NormalConfig ---------------------------------------------------------
$ExeName = "DayZServer_x64.exe"
$ExeDZSA = "DZSALModServer.exe"
$ExePath = "H:\SteamLibrary\steamapps\common\DayZServer\"
$ProfileConfig = "ServerConfig" #Profielname
$ServerDZ = "serverDZ.cfg" #Server Config
$PORT = "2302" #Server Port
$BattleEye = "H:\SteamLibrary\steamapps\common\DayZServer\battleye"

# Client Mods ---------------------------------------------------------
$ModDirSteam = "H:\SteamLibrary\steamapps\common\DayZServer\steamapps\workshop\content\221100\"
#$ModDirDZSA = "H:\SteamLibrary\steamapps\common\DayZ\!dzsal\"
$mods= @(
    [pscustomobject]@{ModID='1559212036';ModName='@CF'}
    [pscustomobject]@{ModID='1680019590';ModName='@Server_Information_Panel'}
    [pscustomobject]@{ModID='1564026768';ModName='@C-O-T'}
)
$ListMods = for ($Modlister = 0; $Modlister -lt $mods.count; $Modlister++){
    "$ModDirSteam{0};" -f $mods.ModID[$Modlister]
}
$Modlist = ($ListMods -join'') #Remove Spacer and LineBreack

# Server Mods ---------------------------------------------------------
$ServerMod= @(
    [pscustomobject]@{ServerModID='00000000000';ServerModName='@None0'}
    [pscustomobject]@{ServerModID='00000000000';ServerModName='@None1'}
)
$ListServerMods = for ($ServerModlister = 0; $ServerModlister -lt $ServerMod.count; $ServerModlister++){
    "$ModDirSteam{0};" -f $ServerMod.ServerModName[$ServerModlister]
}
$ServerModlist = ($ListServerMods -join'') #Remove Spacer and LineBreack

# Parameter ---------------------------------------------------------
$ArgList =@(
    "-profiles=$ProfileConfig",
    "-config=$ServerDZ",
    "-BEPath=$BattleEye",
    "-port=$PORT",
    "-mod=$Modlist",
    "-serverMod=$ServerModlist",
    '-doLogs',
    '-adminLog', 
    '-netLog',
    #'-filePatching',
    #'-cpuCount=8',
    #'-limitFPS=60',
    '-freezeCheck'
)
$ArgListJoin = $ArgList -join' ' #Spacer 
#################################################################
########## DZSA
#################################################################

$ArgListDZSA =@(
    "-port=$PORT",
    "-mod=$Modlist",
    "-skipserver"
)
$ArgListDZSAJoin = $ArgListDZSA -join' ' #Spacer 
$FullPath = "$ExePath$ExeName" #FullPath to Exe
$DZSAModServerPath = "$ExePath$ExeDZSA"

#################################################################
########## Copy Server Keys
#################################################################
Remove-Item -Path "$ExePath\keys" -Exclude dayz.bikey -Recurse
Start-Sleep 1
for ($i = 0; $i -lt $mods.count; $i++){
    $CopyServerKeyPath = $ModDirSteam + $mods.ModID[$i]
    Get-ChildItem -Path "$CopyServerKeyPath" -Include *.bikey -Recurse | Copy-Item -Destination "$ExePath\keys"
}
Write-Host "Copy all Serverkeys"
#################################################################
########## Move Logs
#################################################################
#Get-ChildItem "$ExePath\$ProfileConfig\*" -include *.ADM,*.RPT,.log -Recurse | Move-Item -Destination "$ExePath\$ProfileConfig\LogsFiles\"
$LogPath = $ExePath + $ProfileConfig
$LogPath2 = $ExePath + "ServerLogs"
#Move-Item -Path $LogPath\*.ADM -Destination $LogPath2 
Move-Item -Path $LogPath\*.RPT -Destination $LogPath2 
Move-Item -Path $LogPath\*.log -Destination $LogPath2 
Start-Sleep 1
Write-Host "Remove/Moved old Logs"
#################################################################
########## Create Symlinks for Mods
#################################################################

$strings=@("@*")
Get-Childitem -Path "$ExePath" -Include ($strings) -Recurse -force | Remove-Item -Force -Recurse 
Start-Sleep 2
Write-Host "Remove old Mods"
<#Working Create Symlink #>
for ($i = 0; $i -lt $mods.count; $i++){
    $Target = $ModDirSteam + $Mods.ModID[$i]
    $Destination = $ExePath + $Mods.ModName[$i]
    New-Item -ItemType Junction -Path $Destination -Target $Target
}
Write-Host "Create neu Symlinks"
Start-Sleep 1
#################################################################
########## START DayZServer
#################################################################
Write-Host "Start DayZ Server"
Start-Process -FilePath $FullPath -WorkingDirectory $ExePath -ArgumentList $ArgListJoin
#Write-HOST -FilePath $FullPath -WorkingDirectory $ExePath -ArgumentList $ArgListJoin
#################################################################
########## START DZSA 
#################################################################
Write-Host "Start DZSA-ModServer"
Start-Process -FilePath $DZSAModServerPath -WorkingDirectory $ExePath -ArgumentList $ArgListDZSAJoin
#Write-HOST -FilePath $DZSAModServerPath -WorkingDirectory $ExePath -ArgumentList $ArgListDZSAJoin
