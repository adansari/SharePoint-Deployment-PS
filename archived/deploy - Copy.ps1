
# Load the SharePoint PowerShell Snapin, if not already loaded
.\sub\LoadSharePointSnapin.ps1

Write-Host "Loading deployment config" -ForeGroundColor Green
try
{
   
	$xml = [xml](Get-Content   ".\config.xml")
    
}
catch [Exception]
{
	Write-Host $("* Field does not contain valid XML: "  + $_.Exception.Message) -ForeGroundColor Red
}

# Disable Admin Access Denied Error 
.\sub\SetRemoteAdministratorAccessDenied.ps1 $true



if($xml.exe.solutions -ne $null)
{
	# Add Farm Solutions
	.\sub\DeployFarmSolution.ps1 $xml.exe.solutions
}


# Restart Timer servies
.\sub\RestartTimerService.ps1

if($xml.exe.webapps -ne $null)
{
	# Configure Web Application
	.\sub\ConfigureWebApp.ps1 $xml.exe.webapps
}



# Enable Admin Access Denied Error 
.\sub\SetRemoteAdministratorAccessDenied.ps1 $false


Write-Host "Deployment done successfully!!!"

Read-Host 'Please press ENTER key to close this window' | Out-Null
