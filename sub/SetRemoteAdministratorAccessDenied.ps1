# Turn off/on remote administration security
#
# Description
# -----------
# Turn off/on remote administration security with given information
#
# Command line arguments
# ----------------------
# xmlElement: XML element containing Sub Web configuration parameters

Param([bool]$boolValue)

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint") > $null
[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SharePoint.Administration") > $null

if($boolValue -eq $true)
{
	Write-Host "`n*** Farm Config 'RemoteAdministratorAccessDenied' has been disabled ***" -ForegroundColor Red 
}
else
{
	Write-Host "`n*** Farm Config 'RemoteAdministratorAccessDenied' has been enabled ***" -ForegroundColor Red 	
}

# get content web service
$contentService = [Microsoft.SharePoint.Administration.SPWebService]::ContentService
# turn off remote administration security
$contentService.RemoteAdministratorAccessDenied = $boolValue
$contentService.Update()  
iisreset /noforce
	   