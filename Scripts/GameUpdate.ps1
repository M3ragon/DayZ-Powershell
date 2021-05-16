# DayZ Download an Check (Without Mods)

$ExePath = "D:\Projects\git\DayZ-Powershell\env"
$ZipFile = "steamcmd.zip"
$fileToCheck = "$ExePath\steamcmd.exe"

# Steam Login + Game Update ---------------------------------------------------------
# Have in mind, the account must own DayZ.. you cannot use the "anonymous"User.
# You can Share you Game the an second account to download it but this account cannot download any Workshop content, sadly.
$SteamLogin = "USERNAME" #Steam Username/Login
$SteamPassword = "PASSWORD" #Steam Password
$SteamGuardCode = "XXXXX" #Steam GuardCode
$SteamAppID = "223350" #DayZ Server Steam App ID
$DayZServerPath = "H:\SteamLibrary\steamapps\common\DayZServer\"
$ArgList =@(
    "+login $SteamLogin $SteamPassword $SteamGuardCode",
    "+force_install_dir $DayZServerPath",
    "+app_update $SteamAppID validate",
    "+quit"
)
$ArgListJoin = $ArgList -join' ' #Spacer 

# Check if SteamCMD is there, if not Download
if (Test-Path $fileToCheck -PathType leaf) {
    # Run SteamCMD and Download/Update DayZ
    "SteamCMD is already there"
    Start-Process -FilePath $fileToCheck -WorkingDirectory $ExePath -ArgumentList $ArgListJoin
}
else {
    # Download SteamCMD if not there
    $url = "https://steamcdn-a.akamaihd.net/client/installer/$ZipFile"
    $output = "$ExePath\$ZipFile"
    $start_time = Get-Date
    Invoke-WebRequest -Uri $url -OutFile $output
    Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
    Expand-Archive -Path "$ExePath\$ZipFile" -DestinationPath $ExePath
}
