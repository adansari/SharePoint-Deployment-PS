# Sets Property for the web
#
# Description
# -----------
# Sets Property for the web
#
# Command line arguments
# ----------------------
# xmlElement: XML element containing propertybag
# key: name for the web property
# value: value for the web property for selected key
Param([Xml.XmlElement]$xmlElement, [string]$url)

if($xmlElement.property -eq $null)
{
	# web properties will be set
	exit
}

Write-Host "Adding/Updating Web properties for '$url'"

$web = Get-SPWeb -Identity $url -ErrorAction SilentlyContinue
$web.AllowUnsafeUpdates = $true;

ForEach($property in $xmlElement.property)
{		
	$private:web_key = $property.key
	$private:web_value = $property.InnerXML
	if (!$web.Properties.ContainsKey($web_key))
	{ 
         $web.Properties.Add($web_key, $web_value);
		 Write-Host -foregroundcolor Yellow "Property added '$web_key':'$web_value'"
	}
	else
	{
         $web.Properties[$web_key] = $web_value;
		 Write-Host -foregroundcolor Green "Property updated with '$web_key':'$web_value'"
	}
	
	$web.Properties.Update();
    $web.Update();
	
	$UpdatedValue =  $web.Properties[$web_key]
	

}
       
$web.AllowUnsafeUpdates = $false;
if ($web -ne $null)
{
    $web.Dispose()

}