# Activates SiteCollection scoped features
#
# Description
# -----------
# Activates SiteCollection scoped features
#
# Command line arguments
# ----------------------
# xmlElement: XML element containing features
# url: url of the SiteCollection
Param([Xml.XmlElement]$xmlElement, [string]$url)

if($xmlElement.feature -eq $null)
{
	# No features provided to be activated
	exit
}

Write-Host "Activating SiteCollection features on '$url'" -ForegroundColor Green 


ForEach($feature in $xmlElement.feature)
{	
	
	$private:feature_name = $feature.name
	$private:feature_mode = $feature.mode
    $private:feature_id = $feature.id
	
	# Check if the feature is available on the farm
	$private:installedfeature = Get-SPFeature -identity $feature_id
	

	if($installedfeature -eq $null) 
	{
		# Feature not found
		Write-Host "  * No Site Collection scoped feature named '$feature_name' was found" -ForegroundColor Red 
		continue 
	}
	
	if($feature_mode -eq $null)
	{
		$feature_mode="act"
	}
		
	
	if($feature_mode -eq "skip")
	{ 
		Write-Host "  * Feature '$feature_name' is set to be ignored" -ForegroundColor Green 
		continue
	}
	
	# Check if feature is already activated in the Site scope
    $private:enabledfeature = Get-SPFeature -Site $url -identity $feature_id -ErrorAction:SilentlyContinue
    
    
	if($enabledfeature -ne $null)
	{
		Write-Host "  * Disable feature '$feature_name' with ID '$feature_id'" -ForegroundColor Green
		Disable-SPFeature -Identity $feature_id -Url $url -Confirm:$false #-ErrorAction:SilentlyContinue
	}
	
	# Check if the feature can be enabled
	Write-Host "  * Enable feature '$feature_name' with ID '$feature_id'" -ForegroundColor Green
	Enable-SPFeature -Identity $feature_id -Url $url #-ErrorAction:SilentlyContinue
}