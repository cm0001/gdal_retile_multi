# powershell script to spawn the gdal_retile_multi tile process windows
# send an email to the owner when done
#
$qgisdir      = "C:\Program Files\QGIS 3.40.5"                  # ← change to your QGIS install location
$qgisbindir   = "$qgisdir\bin"
$qgisappsdir  = "$qgisdir\apps"
$scriptPath   = "$qgisbindir\gdal_retile_multi.py"              # ← review (place gdal_retile_multi.py here) 
$python       = "$qgisappsdir\Python312\python.exe"             # ← review

$basePath     = "\\YOUR\SERVER\WHERE\TILES\STORED"
$workRoot     = "$basePath\PATH\TO\imagepyramid"             # ← review (path to your dataset's imagepyramid location)
$dumpRoot     = "$basePath\PATH\TO\VIRTUAL\MOSAIC"           # ← review (path to your dataset's virtual mosaic VRT file)

$dataset      = "dataset_name"                  # ← change (keep same at each server) THIS IS THE "dataset" part of the virtual mosaic "dataset.VRT" file
$firstProcId  = 1                               # ← change (use different ranges at each server. i.e. - server1: 1-8, server2: 9-16 for totalProcs=16)
$lastProcId   = 8                               # ← change (use different ranges at each server) 
$totalProcs   = 16                              # ← change (keep same at each server used to generate tiles)
$pyrOnly      = $false                          # ← change (keep same at each server used to generate tiles) start with $false & complete level 1, delete any levels >1, then rerun at $true

$serverID     = $env:COMPUTERNAME.ToLower()
$procRange    = $firstProcId..$lastProcId    # comment out if using alternatives below
# or, for example:
# $procRange = @(1,2,3,5,7,8)                # skip 4 and 6
# $procRange = 1..4 + 6..8                   # skip 5

# Split common args into ARRAY so they pass correctly to python
$commonArgsArray1 = @(
    "-v"
    "-resume"
    "-r",           "bilinear"
    "-s_srs",       "EPSG:YOUR_EPSG_CODE"         # review
    "-nproc",       "$totalProcs"
)
if ($pyrOnly) {
    $commonArgsArray1 += "-pyramidOnly"
    $commonArgsArray1 += "-levels"
    $commonArgsArray1 += "8"
} else {
    $commonArgsArray1 += "-levels"
    $commonArgsArray1 += "1"
}

$commonArgsArray2 = @(
    "-useDirForEachRow"
    "-ps",          "2048", "2048"
    "-co",          "TILED=YES"
    "-co",          "BLOCKXSIZE=512"
    "-co",          "BLOCKYSIZE=512"
    "-targetDir",   "$workRoot\$dataset"
    "$dumpRoot\$dataset.vrt"
)
$commonArgsArray = $commonArgsArray1 + $commonArgsArray2

$logFolder = "C:\temp\retile_logs"


# --------------------- Email Settings ---------------------
$smtpServer   = "your_smtp_server.your_domain.your_extension"  # ← CHANGE (i.e. - to your smtp server)
$smtpPort     = 25                                             #   or 587, 465
$fromAddress  = "gdal_retile_$($serverID)@your.email.com"      # ← must look like a valid email
$toAddress    = "your_email@your_domain.your_ext"              # ← CHANGE (or $env:USERNAME@domain.com)

# If authentication is required, uncomment and fill in:
# $credential = Get-Credential -Message "Enter SMTP credentials"
# (then pass -Credential $credential to Send-MailMessage)

# -------------------------------------------------------


if (-not (Test-Path $logFolder)) { New-Item -ItemType Directory -Path $logFolder -Force | Out-Null }

$startTime = Get-Date
Write-Host "Starting $($serverID) - Processes $($procRange[0])–$($procRange[-1]) at $startTime"

$jobs = @()

foreach ($procId in $procRange) {
    $logFile = Join-Path $logFolder "proc_$procId.log"
    $errFile = "$logFile.err"

    # This line is fine – $procId already has the correct value
    $argsList = @("`"$scriptPath`"", "-proc", $procId) + $commonArgsArray

    Write-Host "Launching proc $procId → $python $argsList"

    "Started at $(Get-Date) | Proc $procId | Cmd: $python $argsList" | 
        Out-File -FilePath $logFile -Encoding utf8

    try {
        $job = Start-Process -FilePath $python `
                             -ArgumentList $argsList `
                             -WorkingDirectory $qgisbindir `
                             -RedirectStandardOutput $logFile `
                             -RedirectStandardError $errFile `
                             -NoNewWindow `
                             -PassThru `
                             -ErrorAction Stop
        $jobs += $job
    }
    catch {
        Write-Host "ERROR launching proc $procId : $_" -ForegroundColor Red
        "ERROR: $_" | Out-File -FilePath $errFile -Append
    }
}

Write-Host "All $totalProcs processes launched. Waiting for completion..." -ForegroundColor Yellow

# Wait for all to finish
Wait-Process -InputObject $jobs -ErrorAction SilentlyContinue

Write-Host "$serverID (processes $firstProcId–$lastProcId) finished." -ForegroundColor Green

# Optional: Show tail of logs if something looks wrong
Write-Host "Last 10 lines of first log (proc_$firstProcId):"
Get-Content (Join-Path $logFolder "proc_$firstProcId.log") -Tail 10


# ────────────────────────────────────────────────
#               Duration & Email Logic
# ────────────────────────────────────────────────

$endTime   = Get-Date
$duration  = $endTime - $startTime
$minutes   = $duration.TotalMinutes

$targetFolder = Split-Path $commonArgsArray[-2] -Leaf

$subject = "GDAL Retile Complete - $targetFolder - $serverID ($($procRange[0])-$($procRange[-1])/$($totalProcs))"

$body = @"
Target directory: $($commonArgsArray[-2])

Server: $serverID
Processes: $($procRange[0]) to $($procRange[-1]) (total $($procRange.Count) on $serverID of $totalProcs.)
Started: $startTime
Finished: $endTime
Duration: $($minutes.ToString('N1')) minutes ($($duration.ToString()))
$( if ($pyrOnly) { "PYRAMID job" } else {"BASE LEVEL 0 job"} )
Log files: $logFolder\proc_*.log

Note: This is server-side completion notification.
Check output folder and logs for details.
"@

# Only send email if duration longer than 10 minutes (to avoid miscoded runs sending useless emails)
$MIN_MINUTES_FOR_EMAIL = 10

if ($minutes -gt $MIN_MINUTES_FOR_EMAIL) {
    try {
        Send-MailMessage `
            -From $fromAddress `
            -To $toAddress `
            -Subject $subject `
            -Body $body `
            -SmtpServer $smtpServer `
            -Port $smtpPort `
            -Encoding   UTF8 `
            -UseSsl:$($smtpPort -eq 587 -or $smtpPort -eq 465)

        Write-Host "Email sent (duration = $($minutes.ToString('N1')) min): $subject" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to send email: $_" -ForegroundColor Red
        $body | Out-File -FilePath (Join-Path $logFolder "email_failure.txt") -Encoding utf8
    }
}
else {
    Write-Host "No email sent (duration only $($minutes.ToString('N1')) minutes < $MIN_MINUTES_FOR_EMAIL min)" -ForegroundColor DarkGray
}

Write-Host "$serverID finished." -ForegroundColor Green