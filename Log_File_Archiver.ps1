#############################################
#            Log File Archiver              #
#       Written By: Michael Venema          #
#               Version 1.0                 #
#############################################
#Defines the root path for the web server logs
$sourcePath = "C:\inetpub\logs\LogFiles" ## Change this path if needed
#Final Destination for archives to be moved to
$destPath = "\\networkpath\share"  ## Change this path to a real path before running

#Defines the log file age to be archived
$timeLimit = (Get-Date).AddDays(-30) ##Change this value if you want to archive less than 30 days old

#Gets all directories in the root path and pipes objects to a for each loop
Get-ChildItem -Path $sourcePath -Directory -Recurse | ForEach-Object{
    #Variable used for error handling
    $logpath = $_.FullName
    #Creates a zip file path using each directory name
    $archivePath = "$destPath\$_.zip"
    #Grabs all files older than the defined time limit from each folder under the root folder
    $files = Get-ChildItem -Path $_.FullName -File -Recurse | Where-Object {$_.LastWriteTime -lt $timeLimit} | Select-Object -ExpandProperty FullName -ErrorAction SilentlyContinue
    #Creates an archive of the files in each directory using the derived archive path
    try{
    Compress-Archive -Path $files -DestinationPath $archivePath -Update -ErrorAction Stop
    } catch {
        Write-Host "`nNo Files older than 30 days to archive at $logpath"
    }
}

