$WWWROOTDIR = "C:\inetpub\wwwroot"
$WWWOLDDIR = "C:\inetpub\wwwold"
if(!(Test-Path -Path $WWWROOTDIR )){
    Rename-Item -Path $WWWOLDDIR -NewName $WWWROOTDIR
}