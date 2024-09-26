## Configuration
$sourceDir = "C:\Path\To\Your\SourceDirectory"  # Change this to your source directory
$remoteUser = "REMOTE_USER"                      # Remote server username (not used in this script)
$remoteHost = "REMOTE_HOST"                      # Remote server IP or hostname
$remoteDir = "C$\Path\To\Remote\Directory"      # Change this to your remote directory, use C$ for administrative shares

# Create a timestamp for logging
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = "C:\Path\To\Your\LogDirectory\backup_$timestamp.log"  # Change this to your log directory

# Perform the backup using robocopy
Write-Host "Starting backup of $sourceDir to \\$remoteHost\$remoteDir" | Tee-Object -FilePath $logFile
robocopy $sourceDir "\\$remoteHost\$remoteDir" /E /Z /R:3 /W:5 | Tee-Object -FilePath $logFile

# Check the exit status of robocopy
if ($LASTEXITCODE -eq 0) {
    Write-Host "Backup completed successfully, but no files were copied." | Tee-Object -FilePath $logFile
} elseif ($LASTEXITCODE -eq 1) {
    Write-Host "Backup completed successfully with some files copied." | Tee-Object -FilePath $logFile
} elseif ($LASTEXITCODE -eq 2) {
    Write-Host "Backup completed with some files not copied due to issues." | Tee-Object -FilePath $logFile
} else {
    Write-Host "Backup failed with error code $LASTEXITCODE!" | Tee-Object -FilePath $logFile
}

# Optional: Send email with the log file (requires SMTP setup)
# Send-MailMessage -From "youremail@example.com" -To "recipient@example.com" -Subject "Backup Report - $timestamp" -Body (Get-Content $logFile) -SmtpServer "smtp.yourserver.com"
