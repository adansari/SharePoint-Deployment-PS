# Restart the SharePoint Timerservice
#
# Description
# -----------
# Restarts the SharePoint Timerservice (SPTimerV4)
#
# Command line arguments
# ----------------------
# None

Write-Host "Restarting SharePoint Timerservice" -ForegroundColor Green

Stop-Service SPAdminV4
Start-SPAdminJob 
Start-Service SPAdminV4