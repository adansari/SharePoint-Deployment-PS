# Configure Web Applications
#
# Description
# -----------
# Configure Web Application from the provided XmlElement with given information
#
# Command line arguments
# ----------------------
# xmlElement: XML element containing Web Application configuration parameters

Param([xml.XmlElement]$xmlElement)

if($xmlElement -eq $null)
{
	Write-Host "No web application configuration have been defined in the script. Skipping step." -ForeGroundColor Green
	exit
}


Foreach($webapp in $xmlElement.webapp)
{
     # Load information from the XML
	$sp_webapp_url = $webapp.url
    
    # Get web application
    $spWebApp = Get-SPWebApplication -Identity $sp_webapp_url -ErrorAction:SilentlyContinue

    # Check if the WebApplication was successfully retrieved
    if($spWebApp -eq $null)
    {
	   Write-Host "Configuration of the WebApplication '$sp_webapp_url' was not possible because it has not been found" -ForegroundColor Red
	   continue
    }
    else
    {
       if($webapp.features -ne $null)
	   {
	       # Activates Web Application features
	       .\sub\ActivateWebApplicationFeatures.ps1 $webapp.features $sp_webapp_url
	   }
       
       if($webapp.sites -ne $null)
        {
	       # Creates Site Collection
	       .\sub\CreateSiteCollection.ps1 $webapp.sites
        }
    }
}