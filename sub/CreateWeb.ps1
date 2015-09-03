# Create Sub Web
#
# Description
# -----------
# Creates Sub Web from the provided XmlElement with given information
#
# Command line arguments
# ----------------------
# xmlElement: XML element containing Sub Web configuration parameters

Param([xml.XmlElement]$xmlElement,[string]$sp_sitecol_url)

if($xmlElement -eq $null)
{
	Write-Host "No sub web configuration have been defined in the script. Skipping step." -ForeGroundColor Green
	exit
}


Foreach($web in $xmlElement.web)
{
	# Load information from the XML Element
	$sp_subsite_name = $web.title
	$sp_subsite_template = $web.temp
    $sp_subsute_homeURL = $web.homepage


	if($web.url -eq $null)
	{
		# Current item is the rootweb
		$sp_subsite_url = $sp_sitecol_url + "/"
		$sp_subsite_isroot=$true
	}
	else
	{
		# Current item is a subweb
		$sp_subsite_url = $sp_sitecol_url + $web.url
		$sp_subsite_isroot=$false
	}
	
	# Check if a Subsite with the url already exists
	$existingweb = Get-SPWeb -Identity $sp_subsite_url -ErrorAction SilentlyContinue
	
	if($existingweb -ne $null)
	{
		#if this is the rootweb determine if the script already configured it, if not ask the user what to do with it
	   if($existingweb.Url -ne $existingweb.Site.RootWeb.Url)
	   {
			Write-Host "Subsite with url '$sp_subsite_url' already exists." -ForegroundColor Green
			$result = Read-Host "Replace subsite and all child subsites on '$sp_subsite_url'? [Y/N]"
			if($result -eq "Y")
			{
				Write-Host "Subsite with url '$sp_subsite_url' and all child subsites are being removed" -ForegroundColor Green
				.\sub\RemoveSubsite.ps1 $sp_subsite_url

				 # Create the Subsite
				 Write-Host "Subsite with url '$sp_subsite_url' is being recreated" -ForegroundColor Yellow
				 
				 New-SPWeb -Url "$sp_subsite_url" `
						  -Name "$sp_subsite_name" `
						  -Template "$sp_subsite_template" `
						  -Confirm:$false | Out-Null
						  

				 Write-Host "Subsite with url '$sp_subsite_url' has been recreated" -ForegroundColor Green  
                
			}
	   }
	
	}
	else
	{
		# Recreate the Subsite
		 Write-Host "Subsite with url '$sp_subsite_url' is being created" -ForegroundColor Yellow
				 
		New-SPWeb -Url "$sp_subsite_url" `
			-Name "$sp_subsite_name" `
			-Template "$sp_subsite_template" `
			-Confirm:$false | Out-Null
						  

		Write-Host "Subsite with url '$sp_subsite_url' has been recreated" -ForegroundColor Green         
	}
	
     # Set the web Home page URL
	 .\sub\SetWebHomePage.ps1 $sp_subsite_url $sp_subsute_homeURL   
	 
	 	if($web.propertybag -ne $null)
	{
	   # Add Web Properties
	   .\sub\SetWebProperty.ps1 $web.propertybag $sp_subsite_url
	}    
	
	if($web.features -ne $null)
	{
	   # Activates Web features
	   .\sub\ActivateWebFeatures.ps1 $web.features $sp_subsite_url
	}
	
}