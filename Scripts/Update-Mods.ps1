# DayZ Download an Check (Without Mods)
#
# NOT WORKING AT THE MOMENT!
#
$ExePath = "D:\Projects\git\DayZ-Powershell\env"

# Steam Login + Game Update ---------------------------------------------------------
# Have in mind, the account must own DayZ.. you cannot use the "anonymous"User.
# You can Share you Game the an second account to download it but this account cannot download any Workshop content, sadly.
$SteamLogin = "STEAMUSERNAME" #Steam Username/Login
$SteamPassword = "SUPERPASSWORD" #Steam Password
$SteamGuardCode = "GUARDCODE" #Steam GuardCode
$SteamAppID = "221100" #DayZ Client Steam App ID
$DayZServerPath = "H:\SteamLibrary\steamapps\common\DayZServer"

# Same as $mods and $ServerMod from "Start-DayZServer.ps1"
$WorkshopItemListNew = @(
    [pscustomobject]@{ModID='1559212036';ModName='@CF'}
    [pscustomobject]@{ModID='1680019590';ModName='@Server_Information_Panel'}
    [pscustomobject]@{ModID='1564026768';ModName='@C-O-T'}
)
$ListMods = for ( $WorkshopID = 0; $WorkshopID -lt $WorkshopItemListNew.count; $WorkshopID++){
    "+workshop_download_item $SteamAppID {0}" -f $WorkshopItemListNew.ModID[$WorkshopID]
}

$ArgList =@(
    "+login $SteamLogin $SteamPassword $SteamGuardCode", #First Login
    #"+login $SteamLogin $SteamPassword", #After first Login
    # $SteamGuardCode is only needed for the first Login on a new maschine.
    "+force_install_dir $DayZServerPath",
    "$ListMods",
    "+quit"
)
$ArgListJoin = $ArgList -join' ' #Spacer 

# Check if SteamCMD is there, if not Download
$SteamCMD = "$ExePath\steamcmd.exe"
if (Test-Path $SteamCMD -PathType leaf) {
    # Run SteamCMD and Download/Update DayZ Mods from Workshop
    "SteamCMD is already there"
    Write-Host -FilePath $SteamCMD -WorkingDirectory $ExePath -ArgumentList $ArgListJoin
    Start-Process -FilePath $SteamCMD -WorkingDirectory $ExePath -ArgumentList $ArgListJoin
}
else {
    # Download SteamCMD if not there
    "SteamCMD is not there, do Download"
    Start-Process -FilePath "GameUpdate.ps1" -WorkingDirectory $ExePath
}
