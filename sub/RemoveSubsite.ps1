# Remove Subsite
#
# Description
# -----------
# Removes the provided subsite including all its child subsites
#
# Command line arguments
# ----------------------
# spWeb_url: url of the SPWeb to remove
param([string]$spWeb_url)

# Load information from the XML Element
$sp_web = Get-SPWeb $spWeb_url

if($sp_web -eq $null)
{
	Write-Host $("Unable to remove Subsite with url '" + $spWeb_url + "' since it doesn't exist") -ForeGroundColor Red
	exit
}

ForEach($childWeb in $sp_web.Webs)
{
	.\Scripts\RemoveSubsite.ps1 $childWeb.Url	
}	

Write-Host $("Removing subsite with url '" + $spWeb_url + "'") -ForeGroundColor Green
Remove-SPWeb -Identity "$spWeb_url" -Confirm:$false
