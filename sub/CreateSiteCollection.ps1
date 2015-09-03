# Create Site Collections
#
# Description
# -----------
# Creates Site Collection from the provided XmlElement with given information
#
# Command line arguments
# ----------------------
# xmlElement: XML element containing Site Collection configuration parameters

Param([xml.XmlElement]$xmlElement)

if($xmlElement -eq $null)
{
	Write-Host "No site collection configuration have been defined in the script. Skipping step." -ForeGroundColor Green
	exit
}


Foreach($site in $xmlElement.site)
{
	 # Load information from the XML Element
	$sp_sitecol_name = $site.title
	$sp_sitecol_url = $site.url
	$sp_sitecol_langauge = 1033
	$sp_sitecol_owner = $site.admin
	$sp_sitecol_template = $site.temp
    $sp_sitecol_confirmval = $site.confirmRecreate
    
	$currentuser_username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    
	# Check if a SiteCollection with the url already exists
	if((Get-SPSite -Identity $sp_sitecol_url -ErrorAction SilentlyContinue) -ne $null)
	{
      if($sp_sitecol_confirmval -eq "true")
      {       
		$result = Read-Host "Recreate sitecollection '$sp_sitecol_url'? [Y/N]"
        
		if($result -eq "Y")
		{
			Write-Host "Deleting SiteCollection with url '$sp_sitecol_url'" -ForegroundColor Green
			Remove-SPSite -Identity $sp_sitecol_url -Confirm:$false
			
			Write-Host "Creating Site Collection '$sp_sitecol_name'"  -ForegroundColor Yellow
	
			New-SPSite -Url $sp_sitecol_url `
				   -SecondaryOwnerAlias $currentuser_username `
				   -OwnerAlias "$sp_sitecol_owner" `
				   -Language $sp_sitecol_langauge `
				   -Template $sp_sitecol_template `
				   -Name "$sp_sitecol_name" | Out-Null

	
			Write-Host "Site Collection '$sp_sitecol_name' has been created"  -ForegroundColor Green
            
            Write-Host "Adding Site Collection associated groups"  -ForegroundColor Yellow
            $new_site= Get-SPSite -Identity $sp_sitecol_url
            $new_site.RootWeb.CreateDefaultAssociatedGroups("$sp_sitecol_owner",$currentuser_username,"$sp_sitecol_name")
		} 
		else 
		{
			Write-Host "Skipping replacement of siteCollection with url '$sp_sitecol_url'" -ForegroundColor Green
		} 
      } 
      
      else
      {
          Write-Host "Configuring existing siteCollection with url '$sp_sitecol_url'"
      }        
	}
	else
	{
		Write-Host "Creating Site Collection '$sp_sitecol_name'"  -ForegroundColor Yellow
	
		New-SPSite -Url $sp_sitecol_url `
				   -SecondaryOwnerAlias $currentuser_username `
				   -OwnerAlias "$sp_sitecol_owner" `
				   -Language $sp_sitecol_langauge `
				   -Template $sp_sitecol_template `
				   -Name "$sp_sitecol_name" | Out-Null
	
		Write-Host "Site Collection '$sp_sitecol_name' has been created"  -ForegroundColor Green
        
        
        Write-Host "Adding Site Collection associated groups"  -ForegroundColor Yellow
        $new_site= Get-SPSite -Identity $sp_sitecol_url
        $new_site.RootWeb.CreateDefaultAssociatedGroups("$sp_sitecol_owner",$currentuser_username,"$sp_sitecol_name")
	}
	
	
	if($site.features -ne $null)
	{
	   # Activates Site Collection features
	   .\sub\ActivateSiteCollectionFeatures.ps1 $site.features $sp_sitecol_url
	}
	
	if($site.webs -ne $null)
	{
	   # Creates Subsites
	   .\sub\CreateWeb.ps1 $site.webs $sp_sitecol_url
	}
	
}